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

  pipeline :authenticated do
    plug(Guardian.Plug.Pipeline,
      otp_app: :auth_me,
      module: Timeman.Account.Guardian,
      error_handler: Timeman.Account.ErrorHandler
    )

    plug(:fetch_cookies)
    plug(Guardian.Plug.VerifyCookie)

    plug(Guardian.Plug.VerifyHeader,
      realm: "Bearer",
      max_age: {1, :day},
      token_storage: :cookie
    )

    plug(Guardian.Plug.LoadResource)
    plug(TimemanWeb.Plugs.Auth)
  end

  pipeline :ensure_admin_role do
    plug(TimemanWeb.RoleAuthorizationPlug, ["administrator"])
  end

  pipeline :ensure_manager_role do
    plug(TimemanWeb.RoleAuthorizationPlug, ["manager", "administrator"])
  end

  scope "/api", TimemanWeb do
    pipe_through(:api)

    post("/users", UserController, :register)
    post("/login", SessionController, :login)
  end

  scope "/api", TimemanWeb do
    pipe_through([:api, :authenticated])

    post("/clocks/:user_id", ClockController, :upsert_clock)

    get("/users/:id", UserController, :show)
    get("/clocks/:user_id", ClockController, :clocks_by_user)
    get("/workingtime/:user_id/:id", WorkingTimeController, :getWorkingTime)
    delete("/users/", UserController, :delete)

    put("/users/:id", UserController, :update)
    post("/users/update_password", UserController, :update_password)

    get("/workingtime/:user_id", WorkingTimeController, :showTimeForOneUser)
    put("/workingtime/:id", WorkingTimeController, :update)

    post("/logout", SessionController, :logout)
    post("/current_user", SessionController, :current_user)
  end

  scope "/api", TimemanWeb do
    pipe_through([:api, :authenticated, :ensure_admin_role])

    post("/users/set_role/:id", UserController, :set_role)
    delete("/users/:user_id", UserController, :delete)
  end

  scope "/api", TimemanWeb do
    pipe_through([:api, :authenticated, :ensure_manager_role])
    get("/users/", UserController, :index)
    put("/users/set_role/:id", UserController, :set_role)
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
