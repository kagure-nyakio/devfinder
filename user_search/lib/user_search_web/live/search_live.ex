defmodule UserSearchWeb.SearchLive do
  use UserSearchWeb, :live_view

  alias UserSearch.Profile
  alias UserSearchWeb.SearchQuery

  def mount(_params, _session, socket) do
    { :ok,
      socket
      |> assign(:dev_profile, %{})
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
    |> assign(:changeset, SearchQuery.validate_username(username))
  end

  def search_result(socket, username) do
    socket
    |> assign(:username, username)
    |> get_profile()
  end

  defp get_profile(socket) do
    profile =
      socket.assigns.username
      |> Profile.get_dev_profile
      |> process_profile(socket)
  end

  defp process_profile({:ok, profile}, socket) do
    IO.puts "#{inspect(profile)}"
    socket
    |> assign(:dev_profile, profile)
  end

  defp process_profile({:error, changeset}, socket) do
    socket
    |> assign(:changeset, changeset)
  end

 end
