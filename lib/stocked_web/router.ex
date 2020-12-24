defmodule StockedWeb.Router do
  use StockedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StockedWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StockedWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/products", ProductLive.Index, :index
    live "/products/new", ProductLive.Index, :new
    live "/products/:id/edit", ProductLive.Index, :edit

    live "/products/:id", ProductLive.Show, :show
    live "/products/:id/show/edit", ProductLive.Show, :edit

    live "/suppliers", SupplierLive.Index, :index
    live "/suppliers/new", SupplierLive.Index, :new
    live "/suppliers/:id/edit", SupplierLive.Index, :edit

    live "/suppliers/:id", SupplierLive.Show, :show
    live "/suppliers/:id/show/edit", SupplierLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", StockedWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: StockedWeb.Telemetry
    end
  end
end
