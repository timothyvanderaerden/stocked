defmodule StockedWeb.SupplierLiveTest do
  use StockedWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Stocked.Contract

  @create_attrs %{
    email_address: "some@email.address",
    name: "some name",
    phone_number: "+111111111"
  }
  @update_attrs %{
    email_address: "updated@email.address",
    name: "some updated name",
    phone_number: "+111111112"
  }
  @invalid_attrs %{email_address: nil, name: nil, phone_number: nil}

  defp fixture(:supplier) do
    {:ok, supplier} = Contract.create_supplier(@create_attrs)
    supplier
  end

  defp create_supplier(_) do
    supplier = fixture(:supplier)
    %{supplier: supplier}
  end

  describe "Index" do
    setup [:create_supplier]

    test "lists all supplier", %{conn: conn, supplier: supplier} do
      {:ok, _index_live, html} = live(conn, Routes.supplier_index_path(conn, :index))

      assert html =~ "Listing Supplier"
      assert html =~ supplier.email_address
    end

    test "saves new supplier", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.supplier_index_path(conn, :index))

      assert index_live |> element("a", "New Supplier") |> render_click() =~
               "New Supplier"

      assert_patch(index_live, Routes.supplier_index_path(conn, :new))

      assert index_live
             |> form("#supplier-form", supplier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#supplier-form", supplier: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.supplier_index_path(conn, :index))

      assert html =~ "Supplier created successfully"
      assert html =~ @create_attrs.email_address
    end

    test "updates supplier in listing", %{conn: conn, supplier: supplier} do
      {:ok, index_live, _html} = live(conn, Routes.supplier_index_path(conn, :index))

      assert index_live |> element("#supplier-#{supplier.id} a", "Edit") |> render_click() =~
               "Edit Supplier"

      assert_patch(index_live, Routes.supplier_index_path(conn, :edit, supplier))

      assert index_live
             |> form("#supplier-form", supplier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#supplier-form", supplier: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.supplier_index_path(conn, :index))

      assert html =~ "Supplier updated successfully"
      assert html =~ @update_attrs.email_address
    end

    test "deletes supplier in listing", %{conn: conn, supplier: supplier} do
      {:ok, index_live, _html} = live(conn, Routes.supplier_index_path(conn, :index))

      assert index_live |> element("#supplier-#{supplier.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#supplier-#{supplier.id}")
    end
  end

  describe "Show" do
    setup [:create_supplier]

    test "displays supplier", %{conn: conn, supplier: supplier} do
      {:ok, _show_live, html} = live(conn, Routes.supplier_show_path(conn, :show, supplier))

      assert html =~ "Show Supplier"
      assert html =~ supplier.email_address
    end

    test "updates supplier within modal", %{conn: conn, supplier: supplier} do
      {:ok, show_live, _html} = live(conn, Routes.supplier_show_path(conn, :show, supplier))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Supplier"

      assert_patch(show_live, Routes.supplier_show_path(conn, :edit, supplier))

      assert show_live
             |> form("#supplier-form", supplier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#supplier-form", supplier: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.supplier_show_path(conn, :show, supplier))

      assert html =~ "Supplier updated successfully"
      assert html =~ @update_attrs.email_address
    end
  end
end
