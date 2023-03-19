import Config

config :libcluster,
  topologies: [local: [strategy: Elixir.Cluster.Strategy.LocalEpmd]]
