# for running kubectl
resource "local_file" kubeconfig {
  filename = "${path.module}/kubeconfig"
  content  = var.kube_config_content
}

provider "kubernetes-alpha" {
  config_path = "${path.module}/kubeconfig" // path to kubeconfig
}
