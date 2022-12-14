defmodule GameWeb.Router do
  use GameWeb, :router
  alias RoomController

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GameWeb do
    pipe_through :api

    get "/rooms", RoomController, :get_all
    get "/rooms/:id", RoomController, :get_by_id
    post "/rooms", RoomController, :create
    put "/rooms/join/:id", RoomController, :join
    put "/rooms/start/:id", RoomController, :start_game
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: GameWeb.Telemetry
    end
  end
end
