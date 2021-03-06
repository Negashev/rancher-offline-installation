resource "rancher2_cluster_sync" "cluster" {
  cluster_id =  rancher2_cluster.cluster.id
}

resource "time_sleep" "wait_120_seconds" {
  depends_on = [rancher2_cluster_sync.cluster]
  create_duration = "120s"
}


resource "rancher2_project" "storage" {
  name = "Storage"
  cluster_id = rancher2_cluster_sync.cluster.id
  depends_on = [
    null_resource.install_docker_brain,
    null_resource.install_docker_storage,
    null_resource.install_docker_worker,
    time_sleep.wait_120_seconds
  ]
}

resource "rancher2_namespace" "storage" {
  name = "rook-ceph"
  project_id = rancher2_project.storage.id
  depends_on = [
    rancher2_project.storage,
    time_sleep.wait_120_seconds
  ]
}

resource "rancher2_app" "storage" {
  catalog_name = "bastion"
  name = "rook-ceph"
  project_id = rancher2_project.storage.id
  template_name = "rook-ceph"
  template_version = var.rook_version
  target_namespace = rancher2_namespace.storage.id
  wait = true
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
    "csi.cephcsi.image"= "${var.bastion_host}:5000/quay.io/cephcsi/cephcsi:v3.2.0" #TODO add tag to variables
    "csi.registrar.image"= "${var.bastion_host}:5000/k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.0.1" #TODO add tag to variables
    "csi.provisioner.image"= "${var.bastion_host}:5000/k8s.gcr.io/sig-storage/csi-provisioner:v2.0.0" #TODO add tag to variables
    "csi.snapshotter.image"= "${var.bastion_host}:5000/k8s.gcr.io/sig-storage/csi-snapshotter:v3.0.0" #TODO add tag to variables
    "csi.attacher.image"= "${var.bastion_host}:5000/k8s.gcr.io/sig-storage/csi-attacher:v3.0.0" #TODO add tag to variables
    "csi.resizer.image"= "${var.bastion_host}:5000/k8s.gcr.io/sig-storage/csi-resizer:v1.0.0" #TODO add tag to variables
  }
  depends_on = [
    rancher2_namespace.storage,
    time_sleep.wait_120_seconds
  ]
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [rancher2_app.storage]
  create_duration = "60s"
}

resource "rancher2_namespace" "database" {
  name = "postgres-operator"
  project_id = rancher2_cluster_sync.cluster.default_project_id
  depends_on = [
    null_resource.install_docker_brain,
    null_resource.install_docker_storage,
    null_resource.install_docker_worker,
    time_sleep.wait_120_seconds
  ]
}

resource "rancher2_app" "database" {
  catalog_name = "bastion"
  name = "postgres-operator"
  project_id = rancher2_cluster_sync.cluster.default_project_id
  template_name = "postgres-operator"
  template_version = var.postgres_operator_version
  target_namespace = rancher2_namespace.database.id
  wait = true
  answers = {
    "image.registry" = "${var.bastion_host}:5000/registry.opensource.zalan.do"
    "podLabels.operator" = "zalando-operator"
    "affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[0].labelSelector.matchLabels.operator"= "zalando-operator"
    "affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[0].topologyKey"= "kubernetes.io/hostname"
  }
  depends_on = [
    rancher2_namespace.database,
    time_sleep.wait_120_seconds
  ]
}
