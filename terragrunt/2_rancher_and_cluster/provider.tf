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
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.11.0"
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

# Provider bootstrap config
provider "rancher2" {
  alias = "bootstrap"
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
  insecure  = true
}