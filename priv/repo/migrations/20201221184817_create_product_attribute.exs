defmodule Stocked.Repo.Migrations.CreateProductAttribute do
  use Ecto.Migration

  def change do
    create table(:product_attribute, primary_key: false) do
      add :price, :decimal

      add :product_id, references(:product, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      add :supplier_id, references(:supplier, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      timestamps()
    end

    create index(:product_attribute, [:product_id])
    create index(:product_attribute, [:supplier_id])

    create unique_index(:product_attribute, [:product_id, :supplier_id],
             name: :unique_product_supplier_attribute
           )
  end
end
