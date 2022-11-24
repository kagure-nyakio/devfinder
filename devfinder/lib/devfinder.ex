defmodule Devfinder do
  alias Devfinder.Core.Dev

  @opaque dev :: Dev.t

  @spec find_dev(String.t) :: dev
  defdelegate find_dev(username), to: Dev
 end
