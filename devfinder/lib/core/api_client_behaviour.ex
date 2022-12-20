defmodule Devfinder.Core.ApiClientBehaviour do
  @moduledoc false

  @callback find_dev(username :: String.t()) :: 
  {:ok, Devfinder.Core.Dev.t} | {:error, String.t}
end
