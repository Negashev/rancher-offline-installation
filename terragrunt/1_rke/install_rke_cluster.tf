terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.1.7"
    }
  }
}

resource "tls_private_key" "rke" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pem" { 
  filename = "${path.module}/tls.pem"
  content = tls_private_key.rke.private_key_pem
    depends_on = [
        tls_private_key.rke,
    ]
}

resource "null_resource" "create_ssh" {    
    for_each = toset(var.rancher_nodes)
    # setup docker on rancher nodes
    provisioner "file" {
        source      = "${path.module}/tls.pem"
        destination = "/home/${var.ssh_user}/.ssh/authorized_keys"

        connection {
            type     = "ssh"
            agent    = false
            host     = each.key
            password = var.ssh_password
            user     = var.ssh_user
            port     = var.ssh_port
            timeout  = "30s"
        }
    }
    depends_on = [
        local_file.pem,
    ]
}

# Configure RKE provider
provider "rke" {
  log_file = "rke_debug.log"
}

# Create a new RKE cluster
resource "rke_cluster" "rancher" {
    dynamic nodes {
        for_each = toset(var.rancher_nodes)
        content {
            address = nodes.key
            user    = var.ssh_user
            role    = ["controlplane", "worker", "etcd"]
            ssh_key = tls_private_key.rke.public_key_pem
        }
    }
    # kubernetes_version = var.kubernetes_version # can't support latest verions of rke
    upgrade_strategy {
        drain = false
        max_unavailable_worker = "1"
    }
    private_registries {
        url = "${var.bastion_host}:5000"
        is_default = true
    }
    depends_on = [
        null_resource.install_docker,
        null_resource.create_ssh
    ]
}