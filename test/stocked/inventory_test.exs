defmodule Stocked.InventoryTest do
  use Stocked.DataCase

  alias Stocked.Inventory
  alias Stocked.Catalog
  alias Stocked.Contract

  describe "stock" do
    alias Stocked.Inventory.Stock

    @valid_attrs %{quantity: 42}
    @update_attrs %{quantity: 43}
    @invalid_attrs %{quantity: nil}

    @supplier_attrs %{
      email_address: "some@mail.com",
      name: "some name",
      phone_number: "+3211111111"
    }
    @product_attrs %{description: "some description", name: "some name"}

    def stock_fixture(attrs \\ %{}) do
      {:ok, supplier} = Contract.create_supplier(@supplier_attrs)
      {:ok, product} = Catalog.create_product(@product_attrs)

      {:ok, stock} =
        attrs
        |> Map.put(:supplier_id, supplier.id)
        |> Map.put(:product_id, product.id)
        |> Enum.into(@valid_attrs)
        |> Inventory.create_stock()

      stock
    end

    test "list_stock/0 returns all stock" do
      stock = stock_fixture()
      assert Inventory.list_stock() == [stock]
    end

    test "get_stock!/1 returns the stock with given id" do
      stock = stock_fixture()

      assert Inventory.get_stock!(%{product_id: stock.product_id, supplier_id: stock.supplier_id}) ==
               stock
    end

    test "create_stock/1 with valid data creates a stock" do
      {:ok, supplier} = Contract.create_supplier(@supplier_attrs)
      {:ok, product} = Catalog.create_product(@product_attrs)
      attrs = %{supplier_id: supplier.id, product_id: product.id}

      assert {:ok, %Stock{} = stock} = Inventory.create_stock(Enum.into(attrs, @valid_attrs))
      assert stock.quantity == 42
    end

    test "create_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_stock(@invalid_attrs)
    end

    test "update_stock/2 with valid data updates the stock" do
      stock = stock_fixture()
      assert {:ok, %Stock{} = stock} = Inventory.update_stock(stock, @update_attrs)
      assert stock.quantity == 43
    end

    test "update_stock/2 with invalid data returns error changeset" do
      stock = stock_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_stock(stock, @invalid_attrs)

      assert stock ==
               Inventory.get_stock!(%{
                 product_id: stock.product_id,
                 supplier_id: stock.supplier_id
               })
    end

    test "delete_stock/1 deletes the stock" do
      stock = stock_fixture()
      assert {:ok, %Stock{}} = Inventory.delete_stock(stock)

      assert_raise Ecto.NoResultsError, fn ->
        Inventory.get_stock!(%{product_id: stock.product_id, supplier_id: stock.supplier_id})
      end
    end

    test "change_stock/1 returns a stock changeset" do
      stock = stock_fixture()
      assert %Ecto.Changeset{} = Inventory.change_stock(stock)
    end
  end
end
