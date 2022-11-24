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
    github_link: String.t,
    joined: String.t,
    bio: String.t,
    public_repos: integer,
    followers: integer,
    following: integer,
    twitter_username: String.t,
    blog: String.t,
    company: String.t
  }

  defstruct ~w[avatar_url name login github_url joined_on bio public_repos followers following twitter_username blog company]a

  @spec find_dev(String.t) :: t
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
    body
    |> parse_body
    |> filter_info
  end
  
  defp handle_response({:ok, %Response{body: body}}) do
    body
    |> parse_body
    |> Map.get("message")
  end

  defp parse_body(body) do
    body |> Jason.decode!()
  end

  defp filter_info(%{
    "avatar_url"=> avatar_url, 
    "name" => name, 
    "login"=> login, 
    "html_url" => html_url, 
    "created_at" => created_at, 
    "bio" => bio, 
    "public_repos" => public_repos, 
    "followers" => followers, 
    "following" => following,
    "twitter_username" => twitter_username, 
    "company" => company, 
    "blog" => blog}) do
      %__MODULE__{
        avatar_url: avatar_url,
        name: name,
        login: login,
        github_url: html_url,
        joined_on: parse_date(created_at),
        bio: bio,
        public_repos: public_repos,
        followers: followers,
        following: following,
        twitter_username: twitter_username,
        blog: blog,
        company: company 
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
end
