variable "kube_config_content" {}

variable "ceph_version" {
  type = string
  default = "v15.2.9-20210224"
}

variable "bastion_host" {
  type = string
  default = "0.0.0.0"
}

variable "public_network" {
  type = string
  default = "0.0.10.0/24"
}

variable "cluster_network" {
  type = string
  default = "0.0.11.0/24"
}
