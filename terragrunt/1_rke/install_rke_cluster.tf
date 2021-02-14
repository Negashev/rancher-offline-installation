terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.1.7"
    }
  }
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
            user    = var.user
            role    = ["controlplane", "worker", "etcd"]
            ssh_key = file(var.private_key)
        }
    }
    kubernetes_version = var.kubernetes_version
    upgrade_strategy {
        drain = false
        max_unavailable_worker = "1"
    }
    private_registries {
        url: "${var.bastion_host}:5000"
        is_default: true
    }
    depends_on = [
        null_resource.install_docker,
    ]
}