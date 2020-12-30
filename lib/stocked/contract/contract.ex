defmodule Stocked.Contract do
  @moduledoc """
  The Contract context.
  """

  import Ecto.Query, warn: false
  alias Stocked.Repo

  alias Stocked.Contract.Supplier

  @doc """
  Returns the list of supplier.

  ## Examples

      iex> list_supplier()
      [%Supplier{}, ...]

  """
  def list_supplier do
    Supplier
    |> order_by(:name)
    |> Repo.all()
  end

  @doc """
  Gets a single supplier.

  Raises `Ecto.NoResultsError` if the Supplier does not exist.

  ## Examples

      iex> get_supplier!(123)
      %Supplier{}

      iex> get_supplier!(456)
      ** (Ecto.NoResultsError)

  """
  def get_supplier!(id), do: Repo.get!(Supplier, id)

  @doc """
  Creates a supplier.

  ## Examples

      iex> create_supplier(%{field: value})
      {:ok, %Supplier{}}

      iex> create_supplier(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_supplier(attrs \\ %{}) do
    %Supplier{}
    |> Supplier.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a supplier.

  ## Examples

      iex> update_supplier(supplier, %{field: new_value})
      {:ok, %Supplier{}}

      iex> update_supplier(supplier, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_supplier(%Supplier{} = supplier, attrs) do
    supplier
    |> Supplier.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a supplier.

  ## Examples

      iex> delete_supplier(supplier)
      {:ok, %Supplier{}}

      iex> delete_supplier(supplier)
      {:error, %Ecto.Changeset{}}

  """
  def delete_supplier(%Supplier{} = supplier) do
    Repo.delete(supplier)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking supplier changes.

  ## Examples

      iex> change_supplier(supplier)
      %Ecto.Changeset{data: %Supplier{}}

  """
  def change_supplier(%Supplier{} = supplier, attrs \\ %{}) do
    Supplier.changeset(supplier, attrs)
  end
end
