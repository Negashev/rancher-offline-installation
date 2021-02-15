output "api_server_url" {
  value = rke_cluster.rancher.api_server_url
}

output "kube_admin_user" {
  value = rke_cluster.rancher.kube_admin_user
}

output "client_cert" {
  value = rke_cluster.rancher.client_cert
}

output "client_key" {
  value = rke_cluster.rancher.client_key
}

output "ca_crt" {
  value = rke_cluster.rancher.ca_crt
}