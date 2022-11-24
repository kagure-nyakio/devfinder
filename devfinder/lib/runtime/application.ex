defmodule Devfinder.Runtime.Application do
  @moduledoc false

  @req_pool_size 25

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      finch_child_spec()
    ]

    opts = [strategy: :one_for_one, name: Devfinder.Supervisor]

    Supervisor.start_link(children, opts)
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
