resource "rancher2_namespace" "metallb" {
  name = "metallb-system"
  project_id = var.system_project_id
}

resource "rancher2_app" "database" {
  catalog_name = "bastion"
  name = "metallb"
  project_id = var.system_project_id
  template_name = "metallb"
  template_version = var.postgres_operator_version
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
