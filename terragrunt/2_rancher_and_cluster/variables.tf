variable "api_server_url" {}
variable "kube_admin_user" {}
variable "client_cert" {}
variable "client_key" {}
variable "ca_crt" {}
variable "bastion_host" {
  type = string
  default = "0.0.0.0"
}
variable "cert_manager_version" {
  type = string
  default = "v1.0.4"
}
variable "rancher_version" {
  type = string
  default = "v2.5.5"
}
variable "rancher_hostname" {
  type = string
  default = "my.company.com"
}
variable "rancher_password" {
  type = string
  default = "passw0rd"
}
variable "cluster_name" {
  type = string
  default = "cluster1"
}
variable "cluster_nodes" {
  default = {
    "brain"=["0.0.0.4","0.0.0.5","0.0.0.6"],
    "storage"={"0.0.0.7":"10.10.10.7","0.0.0.8":"10.10.10.8","0.0.0.9":"10.10.10.9"},
    "worker"=["0.0.0.10","0.0.0.11","0.0.0.12"]
    }
}