use Mix.Config

# Import the config/test.secret.exs which loads secrets
# and configuration from environment variables.
import_config "test.secret.exs"

# Override Database credentials which are set in `test.secret.exs`
config :stocked, Stocked.Repo, pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stocked, StockedWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
