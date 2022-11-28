defmodule Devfinder.MixProject do
  use Mix.Project

  def project do
    [
      app: :devfinder,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: { Devfinder.Runtime.Application, [] }
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.13.0"},
      {:jason, "~> 1.4"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
