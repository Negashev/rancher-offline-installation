resource "rancher2_namespace" "metallb" {
  name = "metallb-system"
  project_id = var.system_project_id
}

resource "rancher2_app" "metallb" {
  catalog_name = "bastion"
  name = "metallb"
  project_id = var.system_project_id
  template_name = "metallb"
  template_version = var.metallb_version
  target_namespace = rancher2_namespace.metallb.id
  wait = true
  answers = {
    "global.imageRegistry" = "${var.bastion_host}:5000/docker.io"
    "configInline.address-pools[0].name" = "default"
    "configInline.address-pools[0].protocol"= "layer2"
    "configInline.address-pools[0].addresses[0]"= var.metallb_addresses
  }
  depends_on = [
    rancher2_namespace.metallb
  ]
}

resource "rancher2_namespace" "ingress" {
  name = "ingress-nginx"
  project_id = var.system_project_id
}


resource "rancher2_app" "ingress" {
  catalog_name = "bastion"
  name = "ingress-nginx"
  project_id = var.system_project_id
  template_name = "ingress-nginx"
  template_version = var.ingress_version
  target_namespace = rancher2_namespace.ingress.id
  wait = true
  answers = {
    "controller.image.digest" = ""
    "controller.image.repository" = "${var.bastion_host}:5000/k8s.gcr.io/ingress-nginx/controller"
    "controller.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[0].topologyKey" = "kubernetes.io/hostname"
    "controller.replicaCount" = "2"
  }
  depends_on = [
    rancher2_namespace.ingress,
    rancher2_app.metallb
  ]
}
