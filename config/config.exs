# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :videologue,
  ecto_repos: [Videologue.Repo]

config :videologue_web,
  ecto_repos: [Videologue.Repo],
  generators: [context_app: :videologue]

# Configures the endpoint
config :videologue_web, VideologueWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G38fJdEx3x0lF49HiGOuSo2cC3oVBDVe6gxOf0DVltPC1tO8wColRB1vysccalj0",
  render_errors: [view: VideologueWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Videologue.PubSub,
  live_view: [signing_salt: "pxSHQ/+i"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
