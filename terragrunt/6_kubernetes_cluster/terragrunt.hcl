dependencies {
  paths = ["../5_rancher_and_cluster"]
}

dependency "cluster" {
  config_path = "../5_rancher_and_cluster"
  mock_outputs = {
    kube_config_content = "temporary-dummy-id"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
    token_key = dependency.cluster.outputs.kube_config_content
}

retryable_errors = [
  "(?s).*no matches for kind .* in group .*"
]
