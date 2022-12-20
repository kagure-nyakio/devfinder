defmodule Devfinder.Runtime.Application do
  @moduledoc false

  @req_pool_size 50

  use Application

  @impl true
  def start(_type, _args) do
    child_spec = [ 
      finch_child_spec(),
      {
        DynamicSupervisor, strategy: :one_for_one, name: ClientSupervisor
      }
    ]

    opts = [
      name: DevfinderClient.Supervisor,
      strategy: :one_for_one
    ]
  
    Supervisor.start_link(child_spec,  opts)
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

  def start_client() do
    DynamicSupervisor.start_child(
      ClientSupervisor,
      { Devfinder.Runtime.Server, nil}
    )
  end
end
