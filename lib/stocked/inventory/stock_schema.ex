defmodule Stocked.Inventory.Stock do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stocked.Catalog
  alias Stocked.Contract

  @primary_key false
  @foreign_key_type :binary_id
  schema "stock" do
    field :quantity, :integer
    belongs_to :product, Catalog.Product, primary_key: true
    belongs_to :supplier, Contract.Supplier, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:quantity, :product_id, :supplier_id])
    |> validate_required([:quantity, :product_id, :supplier_id])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
  end
end
