defmodule UserSearchWeb.SearchLive do
  use UserSearchWeb, :live_view

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
    |> set_dev_profile(Devfinder.find_dev(username))
  end

  defp set_dev_profile(socket, %{error: "Not Found"}) do
    socket
    |> put_flash(:info, "No results")
    |> assign(:dev_profile, %{})
  end

  defp set_dev_profile(socket, %{error: message}) do
    socket
    |> put_flash(:info, "Error fetching results")
    |> assign(:dev_profile, %{})
  end

  defp set_dev_profile(socket, profile) do
    socket
    |> clear_flash()
    |> assign(:dev_profile, profile)
  end
end
