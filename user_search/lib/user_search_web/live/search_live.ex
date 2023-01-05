defmodule UserSearchWeb.SearchLive do
  use UserSearchWeb, :live_view

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
    { :noreply, search_result(socket, username) }
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

    username = socket.assigns.username

    username
    |> Devfinder.find_dev
    |> process_profile(socket)
  end

  defp process_profile(%{error: "Not Found"}, socket) do
    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.add_error(:find_dev, "No Result")

      socket
    |> assign(:changeset, changeset)
  end

  defp process_profile(%{error: message}, socket) do
    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.add_error(:find_dev, "Internal Server Error")

      socket
    |> assign(:changeset, changeset)
  end


  defp process_profile(profile, socket) do
    socket
    |> assign(:dev_profile, profile)
  end

 end
