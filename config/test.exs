use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :videologue, Videologue.Repo,
  username: "postgres",
  password: "postgres",
  database: "videologue_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :videologue_web, VideologueWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :videologue, phoenix_token_salt: "user_socket_salt"

config :pbkdf2_elixir, :rounds, 1

config :nfo, :wolfram,
  app_id: "testx",
  http_client: Nfo.Test.HTTPClient

config :videologue_web, check_presence: false
