Mox.defmock(Devfinder.Client.Mock, for: Devfinder.Client)
Application.put_env(:devfinder, :devfinder_client, Devfinder.Client.Mock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Devfinder.Repo, :manual)
