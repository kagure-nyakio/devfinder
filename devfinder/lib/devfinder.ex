defmodule Devfinder do

  alias Devfinder.Core.Dev

  @spec find_dev(String.t) :: {:ok, Dev.t} | {:error, String.t}
  defdelegate find_dev(username), to: Dev
  
 end
