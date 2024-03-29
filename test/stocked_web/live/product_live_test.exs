defmodule StockedWeb.ProductLiveTest do
  use StockedWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Stocked.Catalog

  alias Stocked.Contract

  @stock_attrs %{quantity: 10, required_quantity: 100}
  @stock_invalid_attrs %{quantity: nil, required_quantity: nil}

  @attributes_attrs %{price: 10}
  @attributes_invalid_attrs %{price: nil}

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    stock: @stock_attrs,
    attributes: %{"0" => @attributes_attrs}
  }
  @invalid_attrs %{description: nil, name: nil}
  @invalid_update_attrs Map.merge(@invalid_attrs, %{
                          stock: @stock_invalid_attrs,
                          attributes: %{"0" => @attributes_invalid_attrs}
                        })

  defp fixture(:product) do
    {:ok, product} = Catalog.create_product(@create_attrs)
    product
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end

  defp create_supplier(_) do
    {:ok, supplier} =
      Contract.create_supplier(%{
        email_address: "some@address.com",
        name: "some name",
        phone_number: "+3211111111"
      })

    %{supplier: supplier}
  end

  describe "Index" do
    setup [:create_product, :create_supplier]

    test "lists all product", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Listing Product"
      assert html =~ product.description
    end

    test "saves new product", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("a", "New Product") |> render_click() =~
               "New Product"

      assert_patch(index_live, Routes.product_index_path(conn, :new))

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Product created successfully"
      assert html =~ "some description"
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(index_live, Routes.product_index_path(conn, :edit, product))

      assert index_live
             |> element("a", "Add a price")
             |> render_click() =~ "Price"

      assert index_live
             |> form("#product-form", product: @invalid_update_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated description"
      assert html =~ "color:#DC143C"
    end

    test "deletes product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#product-#{product.id}")
    end
  end

  describe "Show" do
    setup [:create_product, :create_supplier]

    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Show Product"
      assert html =~ product.description
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, show_live, _html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(show_live, Routes.product_show_path(conn, :edit, product))

      assert show_live
             |> element("a", "Add a price")
             |> render_click() =~ "Price"

      assert show_live
             |> form("#product-form", product: @invalid_update_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated description"
    end
  end
end
