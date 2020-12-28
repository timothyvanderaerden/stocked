defmodule Stocked.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product" do
    field :description, :string
    field :name, :string

    has_one :stock, Stocked.Inventory.Stock
    has_many :attributes, Stocked.Catalog.ProductAttributes

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description])
    |> cast_assoc(:stock)
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 2, max: 255)
    |> validate_length(:description, max: 255)
  end
end
