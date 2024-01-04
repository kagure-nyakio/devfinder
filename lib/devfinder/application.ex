defmodule Devfinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DevfinderWeb.Telemetry,
      Devfinder.Repo,
      {DNSCluster, query: Application.get_env(:devfinder, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Devfinder.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Devfinder.Finch},
      {Finch, name: Devfinder.Client.Http},
      # Start a worker by calling: Devfinder.Worker.start_link(arg)
      # {Devfinder.Worker, arg},
      # Start to serve requests, typically the last entry
      DevfinderWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Devfinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DevfinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
