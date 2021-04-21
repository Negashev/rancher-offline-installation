variable "api_url" {}
variable "token_key" {}
variable "system_project_id" {}

variable "bastion_host" {
  type = string
  default = "0.0.0.0"
}

variable "metallb_version" {
  type = string
  default = "2.3.5"
}

variable "metallb_addresses" {
  type = string
  default = "0.0.0.10-0.0.0.50"
}
