defmodule UserSearchWeb.SearchQuery do
  @types %{username: :string}

  import Ecto.Changeset

  def validate_username(params) do
    {%{}, @types}
    |> cast(params, Map.keys(@types))
    |> validate_required([:username])
    |> Map.put(:action, :username)
  end
end
