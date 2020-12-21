defmodule Stocked.Repo.Migrations.CreateSupplier do
  use Ecto.Migration

  def change do
    create table(:supplier, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :phone_number, :string
      add :email_address, :string

      timestamps()
    end
  end
end
