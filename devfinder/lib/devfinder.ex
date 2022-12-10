defmodule Devfinder do
  alias Devfinder.Type

  @type user_info :: Type.user_info
  @type error     :: Type.github_error

  @spec find_dev(String.t) :: user_info | error
  def find_dev(username) do
    Devfinder.Core.Dev.find_dev(username)
  end
  
 end
