defmodule Stocked.Inventory.Stock do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stocked.Catalog

  @primary_key false
  @foreign_key_type :binary_id
  schema "stock" do
    field :quantity, :integer
    field :required_quantity, :integer
    belongs_to :product, Catalog.Product, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:quantity, :required_quantity, :product_id])
    |> validate_required([:quantity, :required_quantity, :product_id])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_number(:required_quantity, greater_than_or_equal_to: 0)
  end
end
