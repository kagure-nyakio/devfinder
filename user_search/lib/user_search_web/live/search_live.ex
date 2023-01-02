defmodule UserSearchWeb.SearchLive do
  use UserSearchWeb, :live_view

  alias UserSearchWeb.SearchQuery 

  def mount(_params, _session, socket) do
    { :ok,
      socket
      |> validate(%{})
      |> search(%{})
    }
  end

  def render(assigns) do
    ~H"""
    <div>
 	    <.form
		    let={f}
		    for={@changeset},
		    id="search-form"
        as = "username" 
		    phx-change="validate"
        phx-submit="search">   
      
        <%= text_input f, :username, phx_debounce: "blur" %>
        <%= error_tag f, :username %>

        <%= submit "Search", phx_disable_with: "Searching..." %>
      </.form>
    </div>

    <pre>
      <%= inspect @changeset %>
      <%= inspect @username %>
    </pre>
    """
  end

  def handle_event("validate", %{"username" => username}, socket) do
    { :noreply, validate(socket, username) }
  end

  def handle_event("search", %{"username" => username}, socket) do
    { :noreply, search(socket, username)}
  end

  def validate(socket, username) do
    socket
    |> assign(:changeset, SearchQuery.validate(username))
  end

  def search(socket, username) do
    socket
    |> assign(:username, username)
  end
end
