resource "kubernetes_namespace" "rancher" {
  metadata {
    name = "cattle-system"
  }
}

resource "helm_release" "rancher" {
  namespace  = kubernetes_namespace.rancher.id
  wait       = "true"
  name       = "rancher"
  chart      = "http://${var.bastion_host}:8080/charts/rancher-${var.rancher_helm_version}.tgz"

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
    value = var.rancher_image_tag
  }
 
}
