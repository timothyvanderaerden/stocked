defmodule Stocked.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Stocked.Repo

  alias Stocked.Catalog.Product
  alias Stocked.Catalog.ProductAttributes

  @doc """
  Returns the list of product.

  ## Examples

      iex> list_product()
      [%Product{}, ...]

  """
  def list_product do
    Product
    |> Repo.all()
    |> Repo.preload([:stock])
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    Product
    |> Repo.get!(id)
    |> Repo.preload(:stock)
    |> Repo.preload(attributes: [:supplier])
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  @doc """
  Returns the list of product_attribute.

  ## Examples

      iex> list_product_attribute()
      [%ProductAttributes{}, ...]

  """
  def list_product_attribute do
    Repo.all(ProductAttributes)
  end

  @doc """
  Gets a single product_attributes.

  Raises `Ecto.NoResultsError` if the Product attributes does not exist.

  ## Examples

      iex> get_product_attributes!(123)
      %ProductAttributes{}

      iex> get_product_attributes!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_attributes!(
        %{product_id: _product_id, supplier_id: _supplier_id} = primary_keys
      ) do
    Repo.get_by!(ProductAttributes, primary_keys)
  end

  @doc """
  Creates a product_attributes.

  ## Examples

      iex> create_product_attributes(%{field: value})
      {:ok, %ProductAttributes{}}

      iex> create_product_attributes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_attributes(attrs \\ %{}) do
    %ProductAttributes{}
    |> ProductAttributes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_attributes.

  ## Examples

      iex> update_product_attributes(product_attributes, %{field: new_value})
      {:ok, %ProductAttributes{}}

      iex> update_product_attributes(product_attributes, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_attributes(%ProductAttributes{} = product_attributes, attrs) do
    product_attributes
    |> ProductAttributes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_attributes.

  ## Examples

      iex> delete_product_attributes(product_attributes)
      {:ok, %ProductAttributes{}}

      iex> delete_product_attributes(product_attributes)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_attributes(%ProductAttributes{} = product_attributes) do
    Repo.delete(product_attributes)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_attributes changes.

  ## Examples

      iex> change_product_attributes(product_attributes)
      %Ecto.Changeset{data: %ProductAttributes{}}

  """
  def change_product_attributes(%ProductAttributes{} = product_attributes, attrs \\ %{}) do
    ProductAttributes.changeset(product_attributes, attrs)
  end
end
