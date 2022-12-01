defmodule Devfinder do
  alias Devfinder.Core.Dev
  alias Devfinder.Type

  @spec find_dev(String.t) :: Type.user_info | Type.github_error
  defdelegate find_dev(username), to: Dev
 end
