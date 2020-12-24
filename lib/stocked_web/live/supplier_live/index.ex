defmodule StockedWeb.SupplierLive.Index do
  use StockedWeb, :live_view

  alias Stocked.Contract
  alias Stocked.Contract.Supplier

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :supplier_collection, list_supplier())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Supplier")
    |> assign(:supplier, Contract.get_supplier!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Supplier")
    |> assign(:supplier, %Supplier{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Supplier")
    |> assign(:supplier, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    supplier = Contract.get_supplier!(id)
    {:ok, _} = Contract.delete_supplier(supplier)

    {:noreply, assign(socket, :supplier_collection, list_supplier())}
  end

  defp list_supplier do
    Contract.list_supplier()
  end
end
