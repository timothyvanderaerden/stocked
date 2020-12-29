defmodule StockedWeb.ProductLive.FormComponent do
  use StockedWeb, :live_component

  alias Stocked.Catalog
  alias Stocked.Catalog.ProductAttributes

  alias Stocked.Contract

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:suppliers, Contract.list_supplier())}
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def handle_event("add-attribute", _, socket) do
    vars =
      Map.get(socket.assigns.changeset.changes, :attributes, socket.assigns.product.attributes)

    product_attribute =
      vars
      |> Enum.concat([
        Catalog.change_product_attributes(%ProductAttributes{temp_id: get_temp_id()})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:attributes, product_attribute)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-attribute", %{"remove" => remove_id}, socket) do
    product_attribute =
      socket.assigns.changeset.changes.attributes
      |> Enum.reject(fn %{data: a} ->
        a.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:attributes, product_attribute)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_product(socket, :edit, product_params) do
    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Catalog.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
end
