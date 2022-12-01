defmodule Devfinder.Core.ApiClientBehaviour do
  alias Devfinder.Type

  @moduledoc false
  @callback find_dev(username :: String.t()) :: 
    Type.user_info | Type.github_error
end
