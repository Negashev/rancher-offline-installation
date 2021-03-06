resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  namespace  = kubernetes_namespace.cert_manager.id
  wait       = "true"
  name       = "cert-manager"
  chart      = "http://${var.bastion_host}:8080/charts/cert-manager-${var.cert_manager_version}.tgz"

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
