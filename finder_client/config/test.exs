import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :finder_client, FinderClientWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ruEmhRQjwyWETBF7WGz3eT/wXggk8WcMmHNwXgt6uCoH37b7jyKEnoxwds4X7lVx",
  server: false

# In test we don't send emails.
config :finder_client, FinderClient.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
