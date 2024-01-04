defmodule Devfinder.Client do
  alias  Devfinder.Client.Http

  @callback find_dev(String.t()) :: {:ok, map()} | {:ok, String.t()} | {:error, String.t()}

  def find_dev(username), do: impl().find_dev(username)

  defp impl(), do: Application.get_env(:devfinder, :devfinder_client, Http)
end
