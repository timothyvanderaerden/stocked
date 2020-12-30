defmodule StockedWeb.PageLiveTest do
  use StockedWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Products"
    assert disconnected_html =~ "Suppliers"
    assert render(page_live) =~ "Products"
    assert render(page_live) =~ "Suppliers"
  end
end
