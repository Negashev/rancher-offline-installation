resource "kubernetes_manifest" "postgresql-cluster" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "acid.zalan.do/v1"
    "kind" = "postgresql"
    "metadata" = {
      "name" = "acid-minimal-cluster"
      "namespace" = "default"
    }
    "spec" = {
      "databases" = {
        "foo" = "zalando"
      }
      "dockerImage" = "${var.bastion_host}:5000/registry.opensource.zalan.do/acid/spilo-13:2.0-p2"
      "numberOfInstances" = 3
      "postgresql" = {
        "version" = "13"
      }
      "preparedDatabases" = {
        "bar" = {}
      }
      "teamId" = "acid"
      "users" = {
        "foo_user" = []
        "zalando" = [
          "superuser",
          "createdb",
        ]
      }
      "volume" = {
        "size" = "10Gi"
      }
    }
  }
  wait_for = {
    fields = {
      "status.PostgresClusterStatus" = "Running"
    }
  }
    depends_on = [
        kubernetes_manifest.rook-ceph,
        kubernetes_manifest.block-storage,
        kubernetes_manifest.storage-class
    ]
}
