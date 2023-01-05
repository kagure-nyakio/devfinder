defmodule Devfinder do

  alias Devfinder.Type
  alias Devfinder.Core.Dev

  @spec find_dev(String.t) :: Type.dev_profile | Type.error
  defdelegate find_dev(username), to: Dev
 end
