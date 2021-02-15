# Provider config for admin
provider "rancher2" {
  api_url = var.api_url
  token_key = var.token_key
  insecure = true
}

# Create a new rancher2 resource using admin provider config
resource "rancher2_catalog" "bastion" {
  version = "helm_v3"
  name = "bastion"
  url = "http://${var.bastion_host}:8080"
}