terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.2"
    }    
    helm = {
      source = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

provider "kubernetes" {
  host     = var.api_server_url
  username = var.kube_admin_user

  client_certificate     = var.client_cert
  client_key             = var.client_key
  cluster_ca_certificate = var.ca_crt
  # load_config_file = false
}

provider "helm" {
  kubernetes {
    host     = var.api_server_url
    username = var.kube_admin_user

    client_certificate     = var.client_cert
    client_key             = var.client_key
    cluster_ca_certificate = var.ca_crt
  }
}
