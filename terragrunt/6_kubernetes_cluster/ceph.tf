resource "kubernetes_manifest" "config-map-ceph" {
  provider = kubernetes-alpha
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "config" = <<-EOT
        [global]
        public network = ${var.public_network}
        cluster network = ${var.cluster_network}
        public addr = ""
        cluster addr = ""
        EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "name" = "rook-config-override"
      "namespace" = "rook-ceph"
    }
  }
}



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
              "size" = "${var.data_devices_size != "" ? var.data_devices_size : null}"
            },
            "db_devices" = {
              "size" = "${var.db_devices_size != "" ? var.db_devices_size : null}"
            },
            "journal_devices" = {
              "size" = "${var.journal_devices_size != "" ? var.journal_devices_size : null}"
            },
            "wal_devices" = {
              "size" = "${var.wal_devices_size != "" ? var.wal_devices_size : null}"
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
    depends_on = [
        kubernetes_manifest.config-map-ceph
    ]
}
resource "kubernetes_manifest" "object-storage" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "ceph.rook.io/v1"
    "kind" = "CephObjectStore"
    "metadata" = {
      "name" = "my-store"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "dataPool" = {
        "failureDomain" = "host"
        "replicated" = {
          "size" = 3
        }
      }
      "gateway" = {
        "instances" = 3
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
          "podAntiAffinity" = {
            "requiredDuringSchedulingIgnoredDuringExecution" = [
              {
                "labelSelector" = {
                  "matchExpressions" = [
                    {
                      "key" = "rook_object_store"
                      "operator" = "In"
                      "values" = [
                        "my-store",
                      ]
                    },
                  ]
                }
                "topologyKey" = "kubernetes.io/hostname"
              },
            ]
          }
          "tolerations" = [
            {
              "key" = "storage"
              "operator" = "Equal"
              "value" = "services"
            },
          ]
        }
        "port" = 8888
      }
      "metadataPool" = {
        "failureDomain" = "host"
        "replicated" = {
          "requireSafeReplicaSize" = false
          "size" = 3
        }
      }
      "preservePoolsOnDelete" = true
    }
  }  
    depends_on = [
        kubernetes_manifest.rook-ceph,
    ]
}

resource "kubernetes_manifest" "block-storage" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "ceph.rook.io/v1"
    "kind" = "CephBlockPool"
    "metadata" = {
      "name" = "replicapool"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "failureDomain" = "host"
      "replicated" = {
        "size" = 3
      }
    }
  }
  wait_for = {
    fields = {
      "status.phase" = "Ready"
    }
  }
    depends_on = [
        kubernetes_manifest.rook-ceph,
    ]
}

resource "kubernetes_manifest" "storage-class" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "storage.k8s.io/v1"
    "kind" = "StorageClass"
    "metadata" = {
      "name" = "rook-ceph-block"
      "annotations": {
        "storageclass.beta.kubernetes.io/is-default-class": "true",
        "storageclass.kubernetes.io/is-default-class": "true"
      }
    }
    "parameters" = {
      "clusterID" = "rook-ceph"
      "csi.storage.k8s.io/controller-expand-secret-name" = "rook-csi-rbd-provisioner"
      "csi.storage.k8s.io/controller-expand-secret-namespace" = "rook-ceph"
      "csi.storage.k8s.io/fstype" = "ext4"
      "csi.storage.k8s.io/node-stage-secret-name" = "rook-csi-rbd-node"
      "csi.storage.k8s.io/node-stage-secret-namespace" = "rook-ceph"
      "csi.storage.k8s.io/provisioner-secret-name" = "rook-csi-rbd-provisioner"
      "csi.storage.k8s.io/provisioner-secret-namespace" = "rook-ceph"
      "imageFeatures" = "layering"
      "imageFormat" = "2"
      "pool" = "replicapool"
    }
    "provisioner" = "rook-ceph.rbd.csi.ceph.com"
    "reclaimPolicy" = "Delete"
  }
    depends_on = [
        kubernetes_manifest.block-storage,
    ]
}
