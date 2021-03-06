# Configure the Rancher2 provider to bootstrap and admin
# Provider config for bootstrap
provider "rancher2" {
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
  insecure  = true
}

# Create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  password = var.rancher_password
  telemetry = true
}
