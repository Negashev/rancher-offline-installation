variable "bastion_host" {
  type = string
  default = "0.0.0.0"
}

variable "ssh_password" {
  type = string
  default = "passw0rd"
}

variable "ssh_port" {
  type = number
  default = 22
}

variable "ssh_user" {
  type = string
  default = "user"
}

variable "docker_version" {
  type = string
  default = "19.03.9"
}

variable "rancher_nodes" {
  type = list
  default = []
}

variable "kubernetes_version" {
  type = string
}
