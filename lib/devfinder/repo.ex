defmodule Devfinder.Repo do
  use Ecto.Repo,
    otp_app: :devfinder,
    adapter: Ecto.Adapters.Postgres
end
