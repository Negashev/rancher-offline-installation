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

resource "kubernetes_manifest" "object-storage-user" {
  provider = kubernetes-alpha
  manifest = {
    "apiVersion" = "ceph.rook.io/v1"
    "kind" = "CephObjectStoreUser"
    "metadata" = {
      "name" = "my-user"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "displayName" = "my-display-name"
      "store" = "my-store"
    }
  }
  wait_for = {
    fields = {
      "status.phase" = "Ready"
    }
  }
  depends_on = [
      kubernetes_manifest.block-storage,
      kubernetes_manifest.object-storage,
  ]
}

resource "null_resource" "remove_rook_config_override" {    
    provisioner "remote-exec" {
        inline = [
            "echo ${var.ssh_password} | sudo -S docker run --rm -v ${var.dir_for_kubeconfig}/kubeconfig:/.kube/config ${var.bastion_host}:5000/bitnami/kubectl:${var.kubectl_version} -n rook-ceph delete configmap rook-config-override",
        ]

        connection {
            type     = "ssh"
            agent    = false
            host     = var.bastion_host
            password = var.ssh_password
            user     = var.ssh_user
            port     = var.ssh_port
            timeout  = "30s"
        }
    }
    depends_on = [
      kubernetes_manifest.block-storage,
      kubernetes_manifest.object-storage,
      kubernetes_manifest.object-storage-user,
    ]
}

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
    depends_on = [
        null_resource.remove_rook_config_override
    ]
}


resource "null_resource" "tune_cluster" {    
    provisioner "remote-exec" {
        inline = [
            "echo ${var.ssh_password} | sudo -S docker run --rm -v ${var.dir_for_kubeconfig}/kubeconfig:/.kube/config ${var.bastion_host}:5000/bitnami/kubectl:${var.kubectl_version} -n rook-ceph delete pod --selector=app=rook-ceph-osd",
            "echo ${var.ssh_password} | sudo -S docker run --rm -v ${var.dir_for_kubeconfig}/kubeconfig:/.kube/config ${var.bastion_host}:5000/bitnami/kubectl:${var.kubectl_version} -n cattle-system patch deployment cattle-cluster-agent -p '{\"spec\":{\"template\":{\"spec\":{\"hostNetwork\":true}}}}'",
        ]

        connection {
            type     = "ssh"
            agent    = false
            host     = var.bastion_host
            password = var.ssh_password
            user     = var.ssh_user
            port     = var.ssh_port
            timeout  = "30s"
        }
    }
    depends_on = [
      kubernetes_manifest.config-map-ceph,
    ]
}
