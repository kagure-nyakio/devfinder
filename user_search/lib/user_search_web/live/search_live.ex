defmodule UserSearchWeb.SearchLive do
  use UserSearchWeb, :live_view

  alias UserSearch.Profile
  alias UserSearchWeb.SearchQuery 

  def mount(_params, _session, socket) do
    { :ok,
      socket
      |> validate(%{})
      |> search_result("octocat")
    }
  end
 
  def handle_event("validate", %{"username" => username}, socket) do
    { :noreply, validate(socket, username) }
  end

 def handle_event("search", %{"username" => %{"username" => username}}, socket) do

   { :noreply, search_result(socket, username)}
  end

  def validate(socket, username) do
    socket
    |> assign(:changeset, SearchQuery.validate(username))
  end

  def search_result(socket, username) do
    socket
    |> assign(:username, username)
    |> get_profile(Profile.get_dev_profile(username))
  end

  # TODO: fix error tag(maybe use existing changeset tags) to use changeset and handling and dev_info not found 
  defp get_profile(socket,  {:error, changeset} ) do
    socket
    |> assign(:errors, ["not found"])
  end

  defp get_profile(socket, {:ok, profile}) do
    socket
    |> assign(:dev_profile, profile)
    |> assign(:errors, [])
  end
 end
