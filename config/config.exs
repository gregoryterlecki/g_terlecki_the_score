# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :g_terlecki_the_score,
  ecto_repos: [GTerleckiTheScore.Repo]

# Configures the endpoint
config :g_terlecki_the_score, GTerleckiTheScoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sHLk1LgsaSIcowzEUVvKQrOPEQZ/7Tfy1G8LD04v4mB1EGZkMhWtweHKjAOxpn9k",
  render_errors: [view: GTerleckiTheScoreWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GTerleckiTheScore.PubSub,
  live_view: [signing_salt: "tGHXgOju"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
