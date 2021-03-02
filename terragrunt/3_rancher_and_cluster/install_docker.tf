resource "null_resource" "install_docker_brain" {    
    for_each = toset(var.cluster_nodes.brain)
    # setup docker on rancher nodes
    provisioner "remote-exec" {
        inline = [
            "echo ${var.ssh_password} | sudo -S usermod -aG root ${var.ssh_user}",
            "echo ${var.ssh_password} | sudo -S curl ${var.bastion_host}/install_docker.sh | sudo -S BASTION_HOST=${var.bastion_host} DOCKER_VERSION=${var.docker_version} bash - ",
            "echo ${var.ssh_password} | ${rancher2_cluster.cluster.cluster_registration_token.0.node_command} --etcd --controlplane",
        ]

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
        rancher2_cluster.cluster,
    ]
}

resource "null_resource" "install_docker_storage" {    
    for_each = toset(keys(var.cluster_nodes.storage))
    # setup docker on rancher nodes
    provisioner "remote-exec" {
        inline = [
            "echo ${var.ssh_password} | sudo -S usermod -aG root ${var.ssh_user}",
            "echo ${var.ssh_password} | sudo -S curl ${var.bastion_host}/install_docker.sh | sudo -S BASTION_HOST=${var.bastion_host} DOCKER_VERSION=${var.docker_version} bash - ",
            "echo ${var.ssh_password} | ${rancher2_cluster.cluster.cluster_registration_token.0.node_command} --worker --label app=storage --taints storage=services:NoSchedule --internal-address ${each.key} --address ${var.cluster_nodes.storage[each.key]}",
        ]

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
        rancher2_cluster.cluster,
    ]
}

resource "null_resource" "install_docker_worker" {    
    for_each = toset(var.cluster_nodes.worker)
    # setup docker on rancher nodes
    provisioner "remote-exec" {
        inline = [
            "echo ${var.ssh_password} | sudo -S usermod -aG root ${var.ssh_user}",
            "echo ${var.ssh_password} | sudo -S curl ${var.bastion_host}/install_docker.sh | sudo -S BASTION_HOST=${var.bastion_host} DOCKER_VERSION=${var.docker_version} bash - ",
            "echo ${var.ssh_password} | ${rancher2_cluster.cluster.cluster_registration_token.0.node_command} --worker",
        ]

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
        rancher2_cluster.cluster,
    ]
}
