import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :sb_widgets, SbWidgets.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "sb_widgets_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sb_widgets, SbWidgetsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "c6E22Pa2+GDL6GtV8XVMXwqHWUPHmH8tzCS9YbbB6aGly1wIAPtg6T8VpXJn4y8O",
  server: false

# In test we don't send emails.
config :sb_widgets, SbWidgets.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
