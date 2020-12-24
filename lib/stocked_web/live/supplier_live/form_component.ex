defmodule StockedWeb.SupplierLive.FormComponent do
  use StockedWeb, :live_component

  alias Stocked.Contract

  @impl true
  def update(%{supplier: supplier} = assigns, socket) do
    changeset = Contract.change_supplier(supplier)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"supplier" => supplier_params}, socket) do
    changeset =
      socket.assigns.supplier
      |> Contract.change_supplier(supplier_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"supplier" => supplier_params}, socket) do
    save_supplier(socket, socket.assigns.action, supplier_params)
  end

  defp save_supplier(socket, :edit, supplier_params) do
    case Contract.update_supplier(socket.assigns.supplier, supplier_params) do
      {:ok, _supplier} ->
        {:noreply,
         socket
         |> put_flash(:info, "Supplier updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_supplier(socket, :new, supplier_params) do
    case Contract.create_supplier(supplier_params) do
      {:ok, _supplier} ->
        {:noreply,
         socket
         |> put_flash(:info, "Supplier created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
