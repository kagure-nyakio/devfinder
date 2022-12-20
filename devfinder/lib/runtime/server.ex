defmodule Devfinder.Runtime.Server do
  
  @type t :: pid

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

  alias Devfinder.Core.Dev

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_) do
    { :ok, %{} }
  end

  def handle_call({ :find_dev, username}, _from, devinfo) do
    resp = Dev.find_dev(username) |> client_resp

    { :reply, resp, devinfo }
  end

   defp client_resp({:ok, resp}) do
     %{
       avatar_url: resp.avatar_url,
       name: parse_empty_values(resp.name, "Not set"),
       login: resp.login,
       html_url: resp.html_url,
       created_at: parse_date(resp.created_at),
       bio: parse_empty_values(resp.bio, "This profile has no bio"),
       public_repos: resp.public_repos,
       followers: resp.followers,
       following: resp.following,
       twitter_username: parse_empty_values(resp.twitter_username, "Not Available"),
       blog: parse_empty_values(resp.blog, "Not Available"),
       company: parse_empty_values(resp.company, "Not Available")
     }
   end

  defp client_resp({:error, message}) do
    {:error, message}
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

  defp parse_empty_values(value, message) when is_nil(value) or value == "", do: message

  defp parse_empty_values(value, _message), do: value

end
