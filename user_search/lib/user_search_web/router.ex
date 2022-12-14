defmodule UserSearchWeb.Router do
  use UserSearchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UserSearchWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserSearchWeb do
    pipe_through :browser

    live "/", SearchLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserSearchWeb do
  #   pipe_through :api
  # end
end
