defmodule TimemanWeb.Router do
  alias WorkingTimeController
  use TimemanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TimemanWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemanWeb do
    pipe_through :api

    post "/clocks/:user_id", ClockController, :create_clock_for_user
    get "/clocks/:user_id", ClockController, :clocks_by_user

    resources "/users", UserController, except: [:new, :edit]

    resources "/workingtime", WorkingTimeController, except: [:index, :edit, :new, :show, :create]
    post "/workingtime/:user_id", WorkingTimeController, :createWithUserRelation
    get "/workingtime/:user_id/:id", WorkingTimeController, :getWorkingTime
    get "/workingtime/:user_id", WorkingTimeController, :showTimeForOneUser

    resources "/teams", TeamController
      post "/teams/:team_id/user/:user_id", TeamController, :add_team
      delete "/teams/:team_id/user/:user_id", TeamController, :remove_team

  end

  scope "/", TimemanWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timeman, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TimemanWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end

    scope "/api/swagger" do
      forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :timeman, swagger_file: "swagger.json"
    end

    def swagger_info do
      %{
        info: %{
          version: "1.0",
          title: "Timeman"
        }
      }
    end
  end
end
