resource "rancher2_project" "storage" {
  name = "Storage"
  cluster_id = rancher2_cluster.cluster.id
  depends_on = [
    null_resource.install_docker_brain,
    null_resource.install_docker_storage,
    null_resource.install_docker_worker,
  ]
}

resource "rancher2_namespace" "storage" {
  name = "rook-ceph"
  project_id = rancher2_project.storage.id
  depends_on = [
    rancher2_project.storage
  ]
}

resource "rancher2_app" "storage" {
  catalog_name = "bastion"
  name = "rook-ceph"
  project_id = rancher2_project.storage.id
  template_name = "rook-ceph"
  template_version = var.rook_version
  target_namespace = rancher2_namespace.storage.id
  answers = {
    "discover.tolerations[0].effect" = "NoSchedule"
    "discover.tolerations[0].key" = "storage"
    "discover.tolerations[0].operator" = "Equal"
    "discover.tolerations[0].value" = "services"
    "enableDiscoveryDaemon" = "true"
    "enableFlexDriver" = "true"
    "image.repository" = "${var.bastion_host}:5000/rook/ceph"
    "image.tag" = var.rook_version
    "tolerations[0].effect" = "NoSchedule"
    "tolerations[0].key" = "storage"
    "tolerations[0].operator" = "Equal"
    "tolerations[0].value" = "services"
  }
  depends_on = [
    rancher2_namespace.storage
  ]
}

resource "rancher2_namespace" "database" {
  name = "postgres-operator"
  project_id = rancher2_cluster.cluster.default_project_id
  depends_on = [
    null_resource.install_docker_brain,
    null_resource.install_docker_storage,
    null_resource.install_docker_worker,
  ]
}

resource "rancher2_app" "database" {
  catalog_name = "bastion"
  name = "postgres-operator"
  project_id = rancher2_cluster.cluster.default_project_id
  template_name = "postgres-operator"
  template_version = var.postgres_operator_version
  target_namespace = rancher2_namespace.database.id
  depends_on = [
    rancher2_namespace.database
  ]
}