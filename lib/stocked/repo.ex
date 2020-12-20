defmodule Stocked.Repo do
  use Ecto.Repo,
    otp_app: :stocked,
    adapter: Ecto.Adapters.Postgres
end
