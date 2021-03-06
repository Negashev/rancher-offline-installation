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