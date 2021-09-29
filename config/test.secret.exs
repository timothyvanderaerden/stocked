# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

require Logger

database_user = System.get_env("POSTGRES_USER") || "postgres"
database_pass = System.get_env("POSTGRES_PASSWORD") || "postgres"
database_name = System.get_env("POSTGRES_DB") || "stocked"
database_host = System.get_env("POSTGRES_HOST") || "localhost"

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stocked, Stocked.Repo,
  username: database_user,
  password: database_pass,
  database: "#{database_name}_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: database_host
