# Provider config for admin
provider "rancher2" {
  api_url = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure = true
}

# Create a new rancher2 resource using admin provider config
resource "rancher2_catalog" "bastion" {
  version = "helm_v3"
  name = "bastion"
  url = "http://${var.bastion_host}:8080"
}