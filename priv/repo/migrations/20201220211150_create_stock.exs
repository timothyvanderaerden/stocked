defmodule Stocked.Repo.Migrations.CreateStock do
  use Ecto.Migration

  def change do
    create table(:stock, primary_key: false) do
      add :quantity, :integer

      add :product_id, references(:product, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      add :supplier_id, references(:supplier, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      timestamps()
    end

    create index(:stock, [:product_id])
    create index(:stock, [:supplier_id])
  end
end
