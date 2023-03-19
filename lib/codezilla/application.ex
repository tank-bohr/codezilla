defmodule Codezilla.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: Codezilla.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Codezilla.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    Application.get_env(:libcluster, :topologies, [])
  end
end
