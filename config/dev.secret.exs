# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

require Logger

database_user =
  System.get_env("POSTGRES_USER") ||
    Logger.alert("environment variable POSTGRES_USER is missing.")

database_pass =
  System.get_env("POSTGRES_PASSWORD") ||
    Logger.alert("environment variable POSTGRES_PASSWORD is missing.")

database_name =
  System.get_env("POSTGRES_DB") ||
    Logger.alert("environment variable POSTGRES_DB is missing.")

database_host =
  System.get_env("POSTGRES_HOST") ||
    Logger.alert("environment variable POSTGRES_HOST is missing.")

# Configure your database
config :stocked, Stocked.Repo,
  username: database_user,
  password: database_pass,
  database: database_name,
  hostname: database_host,
  port: String.to_integer(System.get_env("POSTGRES_PORT") || "5432"),
  show_sensitive_data_on_connection_error: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
