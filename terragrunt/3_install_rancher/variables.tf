variable "api_server_url" {}
variable "kube_admin_user" {}
variable "client_cert" {}
variable "client_key" {}
variable "ca_crt" {}
variable "bastion_host" {
  type = string
  default = "0.0.0.0"
}
variable "rancher_helm_version" {
  type = string
  default = "2.5.5"
}

variable "rancher_image_tag" {
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
