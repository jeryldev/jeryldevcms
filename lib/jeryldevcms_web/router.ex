defmodule JeryldevcmsWeb.Router do
  use JeryldevcmsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JeryldevcmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => "default-src 'self'"}
    plug Beacon.LiveAdmin.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JeryldevcmsWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", JeryldevcmsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:jeryldevcms, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JeryldevcmsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  use Beacon.Router
  use Beacon.LiveAdmin.Router

  scope "/admin" do
    pipe_through :browser
    beacon_live_admin("/")
  end

  scope "/" do
    pipe_through :browser
    beacon_site("/", site: :jeryldev)
  end
end
