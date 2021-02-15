resource "kubernetes_namespace" "rancher" {
  metadata {
    name = "cattle-system"
  }
}

resource "helm_release" "rancher" {
  namespace  = kubernetes_namespace.rancher.id
  name       = "rancher"
  repository = "${var.bastion_host}:8080"
  chart      = "rancher"
  version    = var.rancher_version

  set {
    name  = "hostname"
    value = var.rancher_hostname
  }

  set {
    name  = "ingress.tls.source"
    value = "rancher"
  }

  set {
    name  = "systemDefaultRegistry"
    value = "${var.bastion_host}:5000"
  }

  set {
    name  = "useBundledSystemChart"
    value = "true"
  }

  set {
    name  = "rancherImage"
    value = "${var.bastion_host}:5000/rancher/rancher"
  }

  set {
    name  = "rancherImageTag"
    value = var.rancher_version
  }
    depends_on = [
        helm_release.cert_manager,
    ]
  
}

# Create a new rancher2_bootstrap
resource "rancher2_bootstrap" "admin" {
  provider = "rancher2.bootstrap"
  password = var.rancher_password
  telemetry = true
    depends_on = [
        helm_release.rancher,
    ]
}

# Provider config for admin
provider "rancher2" {
  alias = "admin"

  api_url = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure = true
    depends_on = [
        rancher2_bootstrap.admin,
    ]
}

# Create a new rancher2 resource using admin provider config
resource "rancher2_catalog" "bastion" {
  provider = "rancher2.admin"

  name = "bastion"
  url = "http://${var.bastion_host}:8080"
    depends_on = [
        rancher2.admin,
    ]
}