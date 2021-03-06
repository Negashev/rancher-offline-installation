dependencies {
  paths = ["../1_rke", "../2_install_cert_manager"]
}
dependency "rke" {
  config_path = "../1_rke"
  mock_outputs = {
    api_server_url = "temporary-dummy-id"
    kube_admin_user = "temporary-dummy-id"
    client_cert = "temporary-dummy-id"
    client_key = "temporary-dummy-id"
    ca_crt = "temporary-dummy-id"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}
inputs = {
    api_server_url  = dependency.rke.outputs.api_server_url
    kube_admin_user = dependency.rke.outputs.kube_admin_user
    client_cert     = dependency.rke.outputs.client_cert
    client_key      = dependency.rke.outputs.client_key
    ca_crt          = dependency.rke.outputs.ca_crt
}
