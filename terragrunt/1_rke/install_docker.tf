resource "null_resource" "install_docker" {    
    for_each = toset(var.rancher_nodes)
    # setup docker on rancher nodes
    provisioner "remote-exec" {
        inline = [
            "echo ${var.bastion_password} | sudo -S curl ${var.bastion_host}/install_docker.sh | BASTION_HOST=${var.bastion_host} DOCKER_VERSION=${var.docker_version} sudo bash - ",
        ]

        connection {
            type                 = "ssh"
            agent                = false
            host                 = "${each.key}"
            password             = "${var.bastion_password}"
            user                 = "${var.ssh_user}"
            port                 = "${var.ssh_port}"
        }
    }
}