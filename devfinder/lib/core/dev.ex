defmodule Devfinder.Core.Dev do
  @behaviour Devfinder.Core.ApiClientBehaviour 

  alias Finch.Response
  require Logger

  @base_url "https://api.github.com/users/"

  @type t :: %__MODULE__{
    avatar_url: String.t,
    name: String.t,
    login: String.t,
    html_url: String.t,
    created_at: String.t,
    bio: String.t,
    public_repos: integer,
    followers: integer,
    following: integer,
    twitter_username: String.t,
    blog: String.t,
    company: String.t, 
    location: String.t
  }

  defstruct ~w[avatar_url name login html_url created_at bio public_repos followers following twitter_username blog company location]a

  @spec find_dev(String.t) :: { :ok, t} | {:error, String.t}
  def find_dev(username) do
    username
    |> request_dev_info
    |> handle_response
  end

  defp request_dev_info(username) do
    :get
    |> Finch.build(@base_url <> username)
    |> Finch.request(__MODULE__)
  end

  defp handle_response({:ok, %Response{body: body, status: 200}}) do
    response =
      body
      |> parse_body
      |> filter_info
   
    { :ok, response }
  end
  
  defp handle_response({:ok, %Response{body: body, status: status}}) when status > 400 do
    message =
      body
      |> parse_body
      |> Map.get("message")

    { :error, message }
  end
  
  defp handle_response({:error, reason}) do
    Logger.error("Error #{inspect reason} has occured")

    { :error, reason}
  end

  defp parse_body(body) do
    body |> Jason.decode!()
  end

  defp filter_info(response) do
    %__MODULE__{}
    |> Map.to_list
    |> Enum.reduce(%__MODULE__{}, fn {k, _}, acc ->
        case Map.fetch(response, Atom.to_string(k)) do
          {:ok, v}  -> %{acc | k => v}
          :error    -> acc
        end
      end)
  end
end

