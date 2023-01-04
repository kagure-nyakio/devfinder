defmodule UserSearch.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w[id avatar_url bio blog company location created_at followers following html_url login name public_repos twitter_username]a

  @months %{
    "01" => "Jan",
    "02" => "Feb",
    "03" => "Mar",
    "04" => "Apr",
    "05" => "May",
    "06" => "Jun",
    "07" => "Jul",
    "08" => "Aug",
    "09" => "Sep",
    "10" => "Oct",
    "11" => "Nov",
    "12" => "Dec"
  }

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
   field :error
  end

  def validate_profile_changeset(%{error: "Not Found"} = attrs) do
    %__MODULE__{}
    |> change(attrs)
    |> add_error(:err, "Not Found")
  end

  def validate_profile_changeset(%{error: _message} = attrs) do
    %__MODULE__{}
    |> change(attrs)
    |> add_error(:err, "Internal Server Error")
  end

  def validate_profile_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @attrs)
    |> validate_date()
    |> validate_empty_results([:name, :twitter_username, :blog, :company, :location, :bio])
    |> validate_required(@attrs)
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
      changeset = %{ changeset | action: :profile_not_found }

      { :error, changeset }
    end
  end

  defp validate_empty_results(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      value = get_field(changeset, field)

      if value in ["", nil] do
        alt_text(changeset, field)
      else
        changeset
      end
    end)
  end

  defp validate_date(changeset) do
    date =
      get_field(changeset, :created_at)
      |> parse_date

    changeset
      |> put_change(:created_at, date)

  end

  defp alt_text(changeset, field) when field in [:bio] do
    changeset
    |> put_change(field, "This profile has no bio.")
  end

  defp alt_text(changeset, field) do
    changeset
    |> put_change(field, "Not Available.")
  end

  defp parse_date(created_at)  do
    [date, _time] =
      created_at
      |> String.split("T")

    [year, month, date] = date |> String.split("-")

      [year, @months[month], date]
    |> Enum.reverse
    |> Enum.join(" ")
  end

end
