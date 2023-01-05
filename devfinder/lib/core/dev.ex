defmodule Devfinder.Core.Dev do
  @behaviour Devfinder.Core.ApiClientBehaviour

  alias Finch.Response
  alias Devfinder.Type
  require Logger

  @months %{
    "01" => "Jan",
    "02" => "Feb",
    "03" => "Mar",
    "04" => "Apr",
    "05" => "May",
    "06" => "Jun",
    "07" => "Jul",
    "08" => "Aug",
    "09" => "Sep",
    "10" => "Oct",
    "11" => "Nov",
    "12" => "Dec"
  }


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

  defstruct ~w[id avatar_url name login html_url created_at bio public_repos followers following twitter_username blog company location]a

  @spec find_dev(String.t) :: { :ok, Type.dev_profile } | {:error, Type.error}
  def find_dev(username) do
    username
    |> request_dev_info
    |> handle_response
    |> profile
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


###########################################################################
@spec profile({:ok, t}) :: Type.dev_profile | Type.error
def profile({:ok, resp}) do
    %{
      avatar_url: resp.avatar_url,
      name: parse_empty_values(resp.name, "#{resp.login}"),
      login: resp.login,
      html_url: resp.html_url,
      created_at: parse_date(resp.created_at),
      bio: parse_empty_values(resp.bio, "This profile has no bio"),
      public_repos: resp.public_repos,
      followers: resp.followers,
      following: resp.following,
      twitter_username: parse_empty_values(resp.twitter_username, "Not Available"),
      blog: parse_empty_values(resp.blog, "Not Available"),
      company: parse_empty_values(resp.company, "Not Available"),
      location: parse_empty_values(resp.location, "Not Available")
  }
end

def profile({:error, message}) do
  %{ error: message }
end


defp parse_date(str_date) do
  [date, _time] =
    str_date
    |> String.split("T")

  [year, month, date] = date |> String.split("-")

  [year, @months[month], date]
  |> Enum.reverse
  |> Enum.join(" ")
end

  defp parse_empty_values(value, message) when is_nil(value) or value == "", do: message

  defp parse_empty_values(value, _message), do: value
end
