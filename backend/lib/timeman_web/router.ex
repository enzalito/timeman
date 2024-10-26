defmodule TimemanWeb.Router do
  alias WorkingTimeController
  use TimemanWeb, :router

  # TODO: virer pipeline front
  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {TimemanWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TimemanWeb do
    pipe_through(:api)

    post("/users", UserController, :create)
    post("/login", SessionController, :login)
    post("/logout", SessionController, :logout)
  end

  pipeline :authenticated do
    plug(Guardian.Plug.Pipeline,
      otp_app: :auth_me,
      module: Timeman.Account.Guardian,
      error_handler: Timeman.Account.ErrorHandler
    )

    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.LoadResource)
  end

  scope "/api", TimemanWeb do
    pipe_through([:api, :authenticated])

    get("/clocks/:user_id", ClockController, :clocks_by_user)
    post("/clocks/:user_id", ClockController, :upsert_clock)

    resources("/users", UserController, except: [:new, :edit])
    put("/users/set_role/:id", UserController, :set_role)
    post("/users/update_password", UserController, :update_password)

    resources("/workingtime", WorkingTimeController,
      except: [:index, :delete, :edit, :new, :show, :create]
    )

    get("/workingtime/:user_id/:id", WorkingTimeController, :getWorkingTime)
    get("/workingtime/:user_id", WorkingTimeController, :showTimeForOneUser)

    resources("/teams", TeamController)
    post("/teams/:team_id/user/:user_id", TeamController, :add_team)
    delete("/teams/:team_id/user/:user_id", TeamController, :remove_team)
  end

  scope "/", TimemanWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
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
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: TimemanWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end

    scope "/api/swagger" do
      forward("/", PhoenixSwagger.Plug.SwaggerUI,
        otp_app: :timeman,
        swagger_file: "swagger.json",
        swagger_ui_opts: [
          validatorUrl: nil,
          oauth2RedirectUrl: nil,
          displayOperationId: true
        ]
      )
    end

    def swagger_info do
      TimemanWeb.Swagger.swagger_info()
    end
  end
end
