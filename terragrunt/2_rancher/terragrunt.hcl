dependency "1_rke" {
  config_path = "../1_rke"
}

inputs = {
    api_server_url  = dependency.1_rke.outputs.api_server_url
    kube_admin_user = dependency.1_rke.outputs.kube_admin_user
    client_cert     = dependency.1_rke.outputs.client_cert
    client_key      = dependency.1_rke.outputs.client_key
    ca_crt          = dependency.1_rke.outputs.ca_crt
}