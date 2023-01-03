defmodule UserSearch.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w[id avatar_url bio blog company location created_at followers following html_url login name public_repos twitter_username]a

  @primary_key false
  embedded_schema do
   field :id, :integer
   field :avatar_url
   field :name
   field :login
   field :html_url
   field :created_at
   field :bio,  :string
   field :public_repos, :integer
   field :followers, :integer
   field :following, :integer
   field :twitter_username
   field :blog
   field :company
   field :location
  end

  def validate_profile_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @attrs)
    |> gen_text_if_empty([:name, :twitter_username, :blog, :company, :location, :bio])
    |> validate_required(@attrs)
  end

  defp gen_text_if_empty(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset -> 
      value = get_field(changeset, field)

      if value in ["", nil] do
        alt_empty_text(changeset, field)
      else
        changeset
      end
    end)
  end

  defp alt_empty_text(changeset, field) when field in [:bio] do
    changeset
    |> put_change(field, "This profile has no bio.")
  end

  defp alt_empty_text(changeset, field) do
    changeset
    |> put_change(field, "Not Available")
  end

  def get_dev_profile(username) do
    changeset = 
      username
      |> Devfinder.find_dev
      |> validate_profile_changeset

    if changeset.valid? do
      profile = apply_changes(changeset)
      { :ok, profile }
    else 
      changeset = 
        changeset
        |> add_error(:profile, "No results")

      { :error, %{ changeset | action: :get_profile } }
    end
  end
end
