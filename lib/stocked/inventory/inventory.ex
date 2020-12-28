defmodule Stocked.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Stocked.Repo

  alias Stocked.Inventory.Stock

  @doc """
  Returns the list of stock.

  ## Examples

      iex> list_stock()
      [%Stock{}, ...]

  """
  def list_stock do
    Repo.all(Stock)
  end

  @doc """
  Gets a single stock by product id.

  Raises `Ecto.NoResultsError` if the Stock does not exist.

  ## Examples

      iex> get_stock!(%{product_id: "UUIDv4", supplier_id: "UUIDv4"})
      %Stock{}

      iex> get_stock!(%{product_id: "UUIDv4", supplier_id: "UUIDv4"})
      ** (Ecto.NoResultsError)

  """
  def get_stock!(primary_keys)
      when is_map_key(primary_keys, :product_id) and is_map_key(primary_keys, :supplier_id) do
    Repo.get_by!(Stock, primary_keys)
  end

  @doc """
  Creates a stock.

  ## Examples

      iex> create_stock(%{field: value})
      {:ok, %Stock{}}

      iex> create_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock(attrs \\ %{}) do
    %Stock{}
    |> Stock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stock.

  ## Examples

      iex> update_stock(stock, %{field: new_value})
      {:ok, %Stock{}}

      iex> update_stock(stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock(%Stock{} = stock, attrs) do
    stock
    |> Stock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stock.

  ## Examples

      iex> delete_stock(stock)
      {:ok, %Stock{}}

      iex> delete_stock(stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock(%Stock{} = stock) do
    Repo.delete(stock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock changes.

  ## Examples

      iex> change_stock(stock)
      %Ecto.Changeset{data: %Stock{}}

  """
  def change_stock(%Stock{} = stock, attrs \\ %{}) do
    Stock.changeset(stock, attrs)
  end
end
