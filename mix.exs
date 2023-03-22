defmodule Codezilla.MixProject do
  use Mix.Project

  def project do
    [
      app: :codezilla,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :observer],
      mod: {Codezilla.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:recon, "~> 2.5"}
    ]
  end

  def releases() do
    [
      app: [
        include_executables_for: [:unix]
      ]
    ]
  end
end
