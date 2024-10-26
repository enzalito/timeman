defmodule TimemanWeb.SessionController do
  use TimemanWeb, :controller
  use PhoenixSwagger

  alias Timeman.{Account, Account.User, Account.Guardian}
  alias TimemanWeb.UserJSON
  # def new(conn, _) do
  #   changeset = Account.change_user(%User{})
  #   maybe_user = Guardian.Plug.current_resource(conn)

  #   if maybe_user do
  #     redirect(conn, to: "/protected")
  #   else
  #     render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
  #   end
  # end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    with {:ok, user} <- Account.authenticate_user(username, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_resp_cookie("auth_token", token,
        http_only: true,
        secure: true,
        same_site: "Strict",
        max_age: 60 * 60 * 24
      )
      |> render(UserJSON, :show, user: user)
    else
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials", reason: reason})
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> delete_resp_cookie("guardian_default_token")
    |> json(%{message: "Logout successful"})
  end

  def swagger_definitions do
    %{
      SessionRequest:
        swagger_schema do
          title("SessionRequest")
          description("POST body for login")

          property(
            :user,
            %Schema{
              properties: %{
                username: %{type: :string, description: "User name", required: true},
                password: %{
                  type: :string,
                  description: "password",
                  required: true
                }
              },
              example: %{
                username: "Joe",
                password: "JoesPassword"
              }
            },
            "The user login informations"
          )
        end,
      SessionResponse:
        swagger_schema do
          title("SessionResponse")
          description("Response schema for login")

          property(
            :data,
            %Schema{
              properties: %{
                id: %{type: :string, description: "ID", required: true},
                username: %{type: :string, description: "User name", required: true},
                email: %{
                  type: :string,
                  description: "Email address",
                  format: :email,
                  required: true
                },
                role: %{type: :string, description: "User Role", required: false},
                team: %Schema{
                  properties: %{
                    name: %{type: :string, description: "Team name", required: true}
                  },
                  example: %{
                    name: "Development"
                  }
                }
              },
              example: %{
                id: 1,
                username: "Joe",
                email: "joe@mail.com",
                role: "employee",
                team: [
                  %{name: "Development"}
                ]
              }
            },
            "The user details"
          )
        end
    }
  end

  swagger_path :login do
    post("/api/login")
    summary("Login")
    produces("application/json")
    deprecated(false)

    parameter(:login, :body, Schema.ref(:SessionRequest), "The user login informations",
      example: %{
        login: %{username: "Joe", password: "JoesPassword"}
      }
    )

    response(201, "OK", Schema.ref(:UserResponse),
      example: %{
        user: %{
          id: 1,
          username: "Joe",
          email: "joe@mail.com",
          role: "employee",
          team: [
            %{name: "Development"}
          ]
        }
      }
    )
  end

  swagger_path :logout do
    PhoenixSwagger.Path.post("/api/logout")
    summary("logout user")
    produces("application/json")
    deprecated(false)
    security([%{Bearer: []}])

    response(204, "OK")
  end
end
