defmodule Devfinder.Core.ApiClientBehaviour do
  @moduledoc false
  @callback find_dev(username :: String.t()) :: 
    {:ok, dev_info :: term} | 
    {:error, {status :: integer, message :: String.t()}}
end
