defmodule Stocked.Catalog.ProductAttributes do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stocked.Catalog
  alias Stocked.Contract

  @primary_key false
  @foreign_key_type :binary_id
  schema "product_attribute" do
    field :price, :decimal
    belongs_to :product, Catalog.Product, primary_key: true
    belongs_to :supplier, Contract.Supplier, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(product_attributes, attrs) do
    product_attributes
    |> cast(attrs, [:price, :product_id, :supplier_id])
    |> validate_required([:price, :product_id, :supplier_id])
    |> validate_number(:price, greater_than_or_equal_to: 0)
  end
end
