# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :chat_web,
  ecto_repos: [ChatWeb.Repo],
  adapter: Ecto.Adapters.Postgres,
  database: "chat_web_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"


# Configures the Ecto Repository
config :chat_web,
  ecto_repos: [ChatWeb.Repo]

# Configures the endpoint
config :chat_web, ChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "REaiFm60L5WLRshOJOGwTLhT0eRJgqoq+IezkrU5cjqlbOfYcb+L6U6557roHMRv",
  render_errors: [view: ChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChatWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
 issuer: "ChatWeb.#{Mix.env}",
 ttl: {30, :days},
 verify_issuer: true,
 serializer: ChatWeb.GuardianSerializer,
 secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
