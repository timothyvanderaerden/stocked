defmodule Stocked.ContractTest do
  use Stocked.DataCase

  alias Stocked.Contract

  describe "supplier" do
    alias Stocked.Contract.Supplier

    @valid_attrs %{
      email_address: "some@address.com",
      name: "some name",
      phone_number: "+3211111111"
    }
    @update_attrs %{
      email_address: "some@email_address.com",
      name: "some updated name",
      phone_number: "+3211111112"
    }
    @invalid_attrs %{email_address: nil, name: nil, phone_number: nil}

    def supplier_fixture(attrs \\ %{}) do
      {:ok, supplier} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contract.create_supplier()

      supplier
    end

    test "list_supplier/0 returns all supplier" do
      supplier = supplier_fixture()
      assert Contract.list_supplier() == [supplier]
    end

    test "get_supplier!/1 returns the supplier with given id" do
      supplier = supplier_fixture()
      assert Contract.get_supplier!(supplier.id) == supplier
    end

    test "create_supplier/1 with valid data creates a supplier" do
      assert {:ok, %Supplier{} = supplier} = Contract.create_supplier(@valid_attrs)
      assert supplier.email_address == @valid_attrs.email_address
      assert supplier.name == @valid_attrs.name
      assert supplier.phone_number == @valid_attrs.phone_number
    end

    test "create_supplier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contract.create_supplier(@invalid_attrs)
    end

    test "update_supplier/2 with valid data updates the supplier" do
      supplier = supplier_fixture()
      assert {:ok, %Supplier{} = supplier} = Contract.update_supplier(supplier, @update_attrs)
      assert supplier.email_address == @update_attrs.email_address
      assert supplier.name == @update_attrs.name
      assert supplier.phone_number == @update_attrs.phone_number
    end

    test "update_supplier/2 with invalid data returns error changeset" do
      supplier = supplier_fixture()
      assert {:error, %Ecto.Changeset{}} = Contract.update_supplier(supplier, @invalid_attrs)
      assert supplier == Contract.get_supplier!(supplier.id)
    end

    test "delete_supplier/1 deletes the supplier" do
      supplier = supplier_fixture()
      assert {:ok, %Supplier{}} = Contract.delete_supplier(supplier)
      assert_raise Ecto.NoResultsError, fn -> Contract.get_supplier!(supplier.id) end
    end

    test "change_supplier/1 returns a supplier changeset" do
      supplier = supplier_fixture()
      assert %Ecto.Changeset{} = Contract.change_supplier(supplier)
    end
  end
end
