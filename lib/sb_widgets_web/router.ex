defmodule SbWidgetsWeb.Router do
  use SbWidgetsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SbWidgetsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :widget do
    plug :accepts, ["html"]
    plug :fetch_session
    plug(:protect_from_forgery, allow_hosts: ["http://localhost:5001"])
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/sb_widgets", SbWidgetsWeb do
    pipe_through :widget

    get "/token", TokenController, :index

    live_session :widget do
      # live "/meta", MetaWidgetLive, :index
      live "/widget1", FirstWidgetLive, :index
      live "/widget2", SecondWidgetLive, :index
      live "/nav_widget", SportsNavbarLive, :index
      live "/nav_widget/*rest", SportsNavbarLive, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SbWidgetsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sb_widgets, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SbWidgetsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
