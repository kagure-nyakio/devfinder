defmodule Devfinder.Runtime.Server do
  
  @type t :: pid

  alias Devfinder.Core.Dev

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    { :ok, nil }
  end

  def handle_call({ :find_dev, username}, _from, devinfo) do
    devinfo = Dev.find_dev(username)

    { :reply, devinfo, devinfo }
  end
end
