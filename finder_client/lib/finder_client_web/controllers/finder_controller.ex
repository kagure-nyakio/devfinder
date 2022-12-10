defmodule FinderClientWeb.FinderController do
  use FinderClientWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  #post/redirect/get 
  def new(conn, params) do
    username  = params["fetch_info"]["username"]
    user_info = Devfinder.find_dev(username)

    conn = 
      conn
      |> put_session(:user_info, user_info)

    # update input field after inout
    put_in(conn.params["fetch_info"]["username"], "")

    redirect(conn, to: Routes.finder_path(conn, :show))
  end

  def show(conn, _param) do
    dev_info = get_session(conn, :user_info)
    Logger.info(dev_info)


    render(conn, "dev_info.html", dev_info: dev_info)
  end
end
