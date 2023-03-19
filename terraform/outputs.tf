output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.codezilla.kube_config[0].raw_config
  sensitive = true
}
