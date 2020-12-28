defmodule Stocked.Contract.Supplier do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "supplier" do
    field :email_address, :string
    field :name, :string
    field :phone_number, :string

    timestamps()
  end

  @doc false
  def changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [:name, :phone_number, :email_address])
    |> validate_required([:name, :phone_number, :email_address])
    |> validate_length(:name, min: 2, max: 255)
    |> validate_length(:email_address, min: 5, max: 255)
    |> validate_format(:email_address, ~r/@/)
    |> validate_length(:phone_number, min: 9, max: 16)
    |> validate_format(:phone_number, ~r/[+][0-9]*$/)
  end
end
