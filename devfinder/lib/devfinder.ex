defmodule Devfinder do
  alias Devfinder.Runtime.Server
  alias Devfinder.Type

  @opaque client  :: Server.t
  @type user_info :: Type.user_info
  @type error     :: Type.github_error

 @spec start_client() :: client
 def start_client do
   { :ok, client } = Devfinder.Runtime.Application.start_client()
   client
 end

  @spec find_dev(pid, String.t) :: user_info | error
  def find_dev(client, username) do
    GenServer.call(client, { :find_dev, username })
  end 
 end
