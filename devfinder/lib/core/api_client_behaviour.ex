defmodule Devfinder.Core.ApiClientBehaviour do
  @moduledoc false

  alias Devfinder.Type

  @callback find_dev(username :: String.t()) ::
  Type.dev_profile | Type.error
end
