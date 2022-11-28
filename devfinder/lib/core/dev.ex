defmodule Devfinder.Core.Dev do
  alias Finch.Response

  @base_url "https://api.github.com/users/"
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

  @type t :: %__MODULE__{
    avatar_url: String.t,
    name: String.t,
    login: String.t,
    github_url: String.t,
    joined_on: String.t,
    bio: String.t,
    public_repos: integer,
    followers: integer,
    following: integer,
    twitter_username: String.t,
    blog: String.t,
    company: String.t
  }

  defstruct ~w[avatar_url name login github_url joined_on bio public_repos followers following twitter_username blog company]a

  @spec find_dev(String.t) :: { :ok, t } | { :error, { integer, String.t } }
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

    { :error, {status, message} }
  end

  defp parse_body(body) do
    body |> Jason.decode!()
  end

  defp filter_info(resp) do
      %__MODULE__{
        avatar_url: resp["avatar_url"],
        name: resp["name"],
        login: resp["login"],
        github_url: resp["html_url"],
        joined_on: parse_date(resp["created_at"]),
        bio: resp["bio"],
        public_repos: resp["public_repos"],
        followers: resp["followers"],
        following: resp["following"],
        twitter_username: resp["twitter_username"],
        blog: resp["blog"],
        company: resp["company"] 
      }
  end

  defp parse_date(date_joined) do
    [date, _time] = 
      date_joined
      |> String.split("T")

    [year, month, date] = date |> String.split("-")
    
    [year, @months[month], date] 
    |> Enum.reverse
    |> Enum.join(" ")
  end

  #dealing with nil values?? or should this happen in the UI?
end
