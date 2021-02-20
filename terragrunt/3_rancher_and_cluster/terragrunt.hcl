dependencies {
  paths = ["../2_bootstrap_rancher"]
}

dependency "bootstrap" {
  config_path = "../2_bootstrap_rancher"
  mock_outputs = {
    api_url = "temporary-dummy-id"
    token_key = "temporary-dummy-id"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
    api_url   = dependency.bootstrap.outputs.api_url
    token_key = dependency.bootstrap.outputs.token_key
}
