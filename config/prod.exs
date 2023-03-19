import Config

config :libcluster,
  topologies: [
    k8s: [
      strategy: Cluster.Strategy.Kubernetes,
      config: [
        mode: :ip,
        kubernetes_node_basename: "app",
        kubernetes_selector: "app=codezilla",
        kubernetes_service_name: "codezilla-service",
        kubernetes_ip_lookup_mode: :pods,
        kubernetes_namespace: "codezilla"
      ]
    ]
  ]
