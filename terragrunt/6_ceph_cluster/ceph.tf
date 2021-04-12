resource "kubernetes_manifest" "rook-ceph" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "ceph.rook.io/v1"
    "kind" = "CephCluster"
    "metadata" = {
      "name" = "rook-ceph"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "cephVersion" = {
        "image" = "${var.bastion_host}:5000/ceph/ceph:${var.ceph_version}"
      }
      "dashboard" = {
        "enabled" = true
        "ssl" = false
      }
      "dataDirHostPath" = "/var/lib/rook"
      "driveGroups" = [
        {
          "name" = "nvme_index"
          "placement" = {
            "nodeAffinity" = {
              "requiredDuringSchedulingIgnoredDuringExecution" = {
                "nodeSelectorTerms" = [
                  {
                    "matchExpressions" = [
                      {
                        "key" = "app"
                        "operator" = "In"
                        "values" = [
                          "storage",
                        ]
                      },
                    ]
                  },
                ]
              }
            }
            "tolerations" = [
              {
                "key" = "storage"
                "operator" = "Equal"
                "value" = "services"
              },
            ]
          }
          "spec" = {
            "data_devices" = {
              "size" = var.data_devices_size != "" ? var.data_devices_size : null
            },
            "db_devices" = {
              "size" = var.db_devices_size != "" ? var.db_devices_size : null
            },
            "journal_devices" = {
              "size" = var.journal_devices_size != "" ? var.journal_devices_size : null
            },
            "wal_devices" = {
              "size" = var.wal_devices_size != "" ? var.wal_devices_size : null
            }
          }
        },
      ]
      "mgr" = {
        "modules" = [
          {
            "enabled" = true
            "name" = "pg_autoscaler"
          },
        ]
      }
      "mon" = {
        "count" = 3
      }
      "monitoring" = {
        "enabled" = true
      }
      "network" = {
        "hostNetwork" = true
        "provider" = "host"
      }
      "placement" = {
        "all" = {
          "nodeAffinity" = {
            "requiredDuringSchedulingIgnoredDuringExecution" = {
              "nodeSelectorTerms" = [
                {
                  "matchExpressions" = [
                    {
                      "key" = "app"
                      "operator" = "In"
                      "values" = [
                        "storage",
                      ]
                    },
                  ]
                },
              ]
            }
          }
          "tolerations" = [
            {
              "key" = "storage"
              "operator" = "Equal"
              "value" = "services"
            },
          ]
        }
      }
      "removeOSDsIfOutAndSafeToRemove" = true
      "resources" = {
        "mgr" = {
          "limits" = {
            "memory" = "512Mi"
          }
          "requests" = {
            "memory" = "512Mi"
          }
        }
        "mon" = {
          "limits" = {
            "memory" = "512Mi"
          }
          "requests" = {
            "memory" = "512Mi"
          }
        }
      }
    }
  }
  wait_for = {
    fields = {
      "status.phase" = "Ready"
      "status.ceph.health" = "HEALTH_OK"
    }
  }
}