defmodule Stocked.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:product, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
