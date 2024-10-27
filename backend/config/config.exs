# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :timeman,
  ecto_repos: [Timeman.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :timeman, TimemanWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TimemanWeb.ErrorHTML, json: TimemanWeb.ErrorJSON],
    layout: false
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :timeman, Timeman.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :timeman, Timeman.Account.Guardian,
  issuer: "timeman",
  secret_key: "Jz1jFLspBvN32wTlvidnvwi4cWZiMeeRFGca84ZomLEpfpwkKSOOpctcCcfbViLd",
  token_ttl: %{ttl: {1, :day}},
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  json_module: Jason

config :guardian, Guardian.Plug.VerifyCookie,
  # true si HTTPS
  # TODO: régler pour https
  secure: true,
  # 1 jour en secondes
  max_age: 60 * 60 * 24,
  same_site: "Strict"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
