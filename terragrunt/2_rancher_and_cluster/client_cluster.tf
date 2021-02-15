# Create a new rancher2 imported Cluster
resource "rancher2_cluster" "cluster" {
  provider = "rancher2.admin"
  name = var.cluster_name
  rke_config {
    network {
      plugin = "canal"
    }
    services {
      kubelet {
        extra_args {
            volume-plugin-dir = "/usr/libexec/kubernetes/kubelet-plugins/volume/exec"
        }
        extra_binds = [
            "/usr/libexec/kubernetes/kubelet-plugins/volume/exec:/usr/libexec/kubernetes/kubelet-plugins/volume/exec",
        ]
      }
    }
    private_registries {
        url        = "${var.bastion_host}:5000"
        is_default = true
    }
  }
}