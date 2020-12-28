defmodule StockedWeb.ProductLive.Index do
  use StockedWeb, :live_view

  alias Stocked.Catalog
  alias Stocked.Catalog.Product

  @impl true
  def mount(_params, _session, socket) do
    products =
      list_product()
      |> calculate_stock()

    {:ok, assign(socket, :product_collection, products)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Product")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, assign(socket, :product_collection, list_product())}
  end

  defp list_product do
    Catalog.list_product()
  end

  defp calculate_stock(products) do
    products
    |> Enum.map(fn product ->
      total = Enum.reduce(product.stock, 0, fn x, acc -> x.quantity + acc end)
      Map.put(product, :total_stock, total)
    end)
  end
end
