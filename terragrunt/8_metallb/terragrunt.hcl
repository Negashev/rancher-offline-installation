dependencies {
  paths = ["../5_rancher_and_cluster", "../4_bootstrap_rancher"]
}


dependency "bootstrap" {
  config_path = "../4_bootstrap_rancher"
  mock_outputs = {
    api_url = "temporary-dummy-id"
    token_key = "temporary-dummy-id"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "cluster" {
  config_path = "../5_rancher_and_cluster"
  mock_outputs = {
    system_project_id = "temporary-dummy-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
    api_url   = dependency.bootstrap.outputs.api_url
    token_key = dependency.bootstrap.outputs.token_key
    system_project_id  = dependency.cluster.outputs.system_project_id
}

retryable_errors = [
  "(?s).*Cluster ID .* is not active.*"
]
