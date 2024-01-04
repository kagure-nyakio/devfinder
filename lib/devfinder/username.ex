defmodule Devfinder.Username do
  import Ecto.Changeset

  defstruct ~w[username]a

  @types %{username: :string}

  def changeset(%__MODULE__{} = username, attrs \\ %{}) do
    {username, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:username])
  end
end
