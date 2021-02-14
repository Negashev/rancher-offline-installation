resource "null_resource" "install_docker" {    
    for_each = toset(var.rancher_nodes)
    # setup docker on rancher nodes
    provisioner "remote-exec" {
        inline = [
            "echo ${var.ssh_password} | sudo -S curl ${var.bastion_host}/install_docker.sh | sudo -S BASTION_HOST=${var.bastion_host} DOCKER_VERSION=${var.docker_version} bash - ",
            "echo ${var.ssh_password} | sudo -S usermod -aG docker ${var.ssh_user}",
        ]

        connection {
            type     = "ssh"
            agent    = false
            host     = each.key
            password = var.ssh_password
            user     = var.ssh_user
            port     = var.ssh_port
            timeout  = 30s
        }
    }
}