defmodule Stocked.CatalogTest do
  use Stocked.DataCase

  alias Stocked.Catalog

  describe "product" do
    alias Stocked.Catalog.Product

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Catalog.create_product()

      product
    end

    test "list_product/0 returns all product" do
      product = product_fixture()

      assert Catalog.list_product()
             |> Enum.map(fn product ->
               product
               |> Unpreload.forget(:stock)
               |> Unpreload.forget(:attributes, :many)
             end) == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()

      assert Catalog.get_product!(product.id)
             |> Unpreload.forget(:stock)
             |> Unpreload.forget(:attributes, :many) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Catalog.create_product(@valid_attrs)
      assert product.description == "some description"
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Catalog.update_product(product, @update_attrs)
      assert product.description == "some updated description"
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)

      assert product ==
               Catalog.get_product!(product.id)
               |> Unpreload.forget(:stock)
               |> Unpreload.forget(:attributes, :many)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end

  describe "product_attribute" do
    alias Stocked.Catalog.ProductAttributes
    alias Stocked.Catalog
    alias Stocked.Contract

    @valid_attrs %{price: "120.5"}
    @update_attrs %{price: "456.7"}
    @invalid_attrs %{price: nil}

    @supplier_attrs %{
      email_address: "some@mail.com",
      name: "some name",
      phone_number: "+3211111111"
    }
    @product_attrs %{description: "some description", name: "some name"}

    def product_attributes_fixture(attrs \\ %{}) do
      {:ok, supplier} = Contract.create_supplier(@supplier_attrs)
      {:ok, product} = Catalog.create_product(@product_attrs)

      {:ok, product_attributes} =
        attrs
        |> Map.put(:supplier_id, supplier.id)
        |> Map.put(:product_id, product.id)
        |> Enum.into(@valid_attrs)
        |> Catalog.create_product_attributes()

      product_attributes
    end

    test "list_product_attribute/0 returns all product_attribute" do
      product_attributes = product_attributes_fixture()
      assert Catalog.list_product_attribute() == [product_attributes]
    end

    test "get_product_attributes!/1 returns the product_attributes with given id" do
      product_attributes = product_attributes_fixture()

      assert Catalog.get_product_attributes!(%{
               product_id: product_attributes.product_id,
               supplier_id: product_attributes.supplier_id
             }) == product_attributes
    end

    test "create_product_attributes/1 with valid data creates a product_attributes" do
      {:ok, supplier} = Contract.create_supplier(@supplier_attrs)
      {:ok, product} = Catalog.create_product(@product_attrs)
      attrs = %{supplier_id: supplier.id, product_id: product.id}

      assert {:ok, %ProductAttributes{} = product_attributes} =
               Catalog.create_product_attributes(Enum.into(attrs, @valid_attrs))

      assert product_attributes.price == Decimal.new("120.5")
    end

    test "create_product_attributes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product_attributes(@invalid_attrs)
    end

    test "update_product_attributes/2 with valid data updates the product_attributes" do
      product_attributes = product_attributes_fixture()

      assert {:ok, %ProductAttributes{} = product_attributes} =
               Catalog.update_product_attributes(product_attributes, @update_attrs)

      assert product_attributes.price == Decimal.new("456.7")
    end

    test "update_product_attributes/2 with invalid data returns error changeset" do
      product_attributes = product_attributes_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Catalog.update_product_attributes(product_attributes, @invalid_attrs)

      assert product_attributes ==
               Catalog.get_product_attributes!(%{
                 product_id: product_attributes.product_id,
                 supplier_id: product_attributes.supplier_id
               })
    end

    test "delete_product_attributes/1 deletes the product_attributes" do
      product_attributes = product_attributes_fixture()
      assert {:ok, %ProductAttributes{}} = Catalog.delete_product_attributes(product_attributes)

      assert_raise Ecto.NoResultsError, fn ->
        Catalog.get_product_attributes!(%{
          product_id: product_attributes.product_id,
          supplier_id: product_attributes.supplier_id
        })
      end
    end

    test "change_product_attributes/1 returns a product_attributes changeset" do
      product_attributes = product_attributes_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product_attributes(product_attributes)
    end
  end
end
