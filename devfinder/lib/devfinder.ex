defmodule Devfinder do

  alias Devfinder.Type
  alias Devfinder.Core.Dev

  @spec find_dev(String.t) :: Type.dev_profile | Type.github_error
  def find_dev(username) do
    username
    |> Dev.find_dev()
    |> process_result()
  end

  defp process_result({:ok, dev_profile}) do
    Map.from_struct(dev_profile)
  end

  defp process_result({:error, message}), do: %{ error: message }
 end
