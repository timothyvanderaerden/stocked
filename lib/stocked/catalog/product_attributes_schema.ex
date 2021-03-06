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

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true

    timestamps()
  end

  @doc false
  def changeset(product_attributes, attrs) do
    product_attributes
    |> Map.put(:temp_id, product_attributes.temp_id || attrs["temp_id"])
    |> cast(attrs, [:price, :product_id, :supplier_id, :delete])
    |> validate_required([:price, :product_id, :supplier_id])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> unique_constraint(:unique_product_supplier_attribute_constraint,
      name: :unique_product_supplier_attribute
    )
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{product_id: nil, supplier_id: nil}} = changeset),
    do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
