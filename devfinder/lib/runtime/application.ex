defmodule Devfinder.Runtime.Application do
  #Supervisor -> DynamicSupervisor ->  Finch workers to make requesr
  @moduledoc false

  @req_pool_size 25

  use Application

  @impl true
  def start(_type, _args) do
    spec = [
      {
        DynamicSupervisor, strategy: :one_for_one, name: ClientStarter
      },
      finch_child_spec()
    ]

    opts = [strategy: :one_for_one]

    Supervisor.start_link(spec, opts)
  end

  def start_client do
    DynamicSupervisor.start_child(ClientStarter, {Devfinder.Runtime.Server, nil})

  end

  defp finch_child_spec do
    {
      Finch, 
      name: Devfinder.Core.Dev,
      pools: %{
        "https://api.github.com" => [size: @req_pool_size]
      }
    }
  end
end
