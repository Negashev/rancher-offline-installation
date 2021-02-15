resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  namespace  = kubernetes_namespace.cert_manager.name
  name       = "cert-manager"
  repository = "${var.bastion_host}:8080"
  chart      = "cert-manager"
  version    = var.cert_manager_version

  set {
    name  = "image.repository"
    value = "${var.bastion_host}:5000/quay.io/jetstack/cert-manager-controller"
  }

  set {
    name  = "webhook.image.repository"
    value = "${var.bastion_host}:5000/quay.io/jetstack/cert-manager-webhook"
  }

  set {
    name  = "cainjector.image.repository"
    value = "${var.bastion_host}:5000/quay.io/jetstack/cert-manager-cainjector"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }
  
}