variable "api_url" {}
variable "token_key" {}

variable "rook_version" {
  type = string
  default = "v1.5.6"
}

variable "postgres_operator_version" {
  type = string
  default = "v1.6.0"
}

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

variable "rancher_hostname" {
  type = string
  default = "my.company.com"
}
variable "cluster_name" {
  type = string
  default = "cluster1"
}
variable "cluster_nodes" {
  type = object({
    brain = list(string),
    storage = map(any),
    worker = list(string)
  })
  default = {
    "brain"=["0.0.0.4","0.0.0.5","0.0.0.6"],
    "storage"={"0.0.0.7":"10.10.10.7","0.0.0.8":"10.10.10.8","0.0.0.9":"10.10.10.9"},
    "worker"=["0.0.0.10","0.0.0.11","0.0.0.12"]
    }
}
