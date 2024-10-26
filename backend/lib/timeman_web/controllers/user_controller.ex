defmodule TimemanWeb.UserController do
  use TimemanWeb, :controller
  use PhoenixSwagger

  alias Timeman.Account
  alias Timeman.Account.User
  alias Timeman.Account.Guardian
  alias Timeman.Repo
  import Ecto.Query

  alias Timeman.Clocks

  action_fallback(TimemanWeb.FallbackController)

  def index(conn, %{"username" => username}) do
    user = Account.list_users(%{"username" => username})
    render(conn, :show, user: user)
  end

  def index(conn, _param) do
    user = Account.list_users()
    render(conn, :show, user: user)
  end

  def register(conn, %{"user" => user_params}) do
    user_params =
      user_params |> Map.take(["email", "password", "username"])

    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      Clocks.create_default_clock(user.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Account.get_user!(String.to_integer(id))
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(String.to_integer(id))

    user_params =
      user_params |> Map.take(["email", "password", "username"])

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def set_role(conn, %{"id" => id, "user" => %{"role" => role}}) do
    user = Account.get_user!(String.to_integer(id))

    changeset = User.changeset(user, %{"role" => role})

    with {:ok, %User{} = user} <- Account.update_user(user, %{"role" => role}) do
      render(conn, :show, user: user)
    end
  end

  def update_password(conn, %{
        "username" => username,
        "current_password" => current_password,
        "new_password" => new_password
      }) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.username == username do
      case Account.authenticate_user(username, current_password) do
        {:ok, user} ->
          case Account.update_user(user, %{"password" => new_password}) do
            {:ok, updated_user} ->
              conn
              |> put_status(:ok)
              |> render(:show, user: updated_user)

            {:error, changeset} ->
              {:error, changeset}
          end

        {:error, _reason} ->
          {:error, :unauthorized}
      end
    else
      {:error, :unauthorized}
    end
  end

  def update_password(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid parameters"})
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(String.to_integer(id))

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Not authenticated"})

      user ->
        case Account.delete_user(user) do
          {:ok, _} ->
            Guardian.Plug.sign_out(conn)
            send_resp(conn, :no_content, "")

          {:error, _} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Unable to delete user"})
        end
    end
  end

  def swagger_definitions do
    %{
      UserRequest:
        swagger_schema do
          title("UserRequest")
          description("POST body for creating a user")

          property(
            :user,
            %Schema{
              properties: %{
                username: %{type: :string, description: "User name", required: true},
                email: %{
                  type: :string,
                  description: "Email address",
                  format: :email,
                  required: true
                },
                password: %{
                  type: :string,
                  description: "password",
                  required: true
                }
              },
              example: %{
                username: "Joe",
                email: "joe@mail.com",
                password: "JoesPassword"
              }
            },
            "The user details"
          )
        end,
      UserResponse:
        swagger_schema do
          title("UserResponse")
          description("Response schema for single user")

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
        end,
      UserRoleRequest:
        swagger_schema do
          title("UserRoleRequest")
          description("request schema to set new role")

          property(
            :user,
            %Schema{
              properties: %{
                role: %{type: :string, description: "role", required: true}
              },
              example: %{
                role: "manager"
              }
            },
            "The user role"
          )
        end,
      UserPasswordRequest:
        swagger_schema do
          title("UserPasswordRequest")
          description("request schema to set new password")

          property(
            :user,
            %Schema{
              properties: %{
                username: %{type: :string, description: "username", required: true},
                current_password: %{
                  type: :string,
                  description: "current password",
                  required: true
                },
                new_password: %{type: :string, description: "new password", required: true}
              },
              example: %{
                username: "Joe",
                current_password: "JoesCurrentPassword",
                new_password: "JoesNewPassword"
              }
            }
          )
        end
    }
  end

  swagger_path :index do
    get("/api/users")
    summary("Get all users with fuzzy search (manager and administrator)")
    produces("application/json")
    deprecated(false)
    parameter(:username, :query, :string, "fuzzy name search", required: false, example: "Jo")
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
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

  swagger_path :show do
    get("/api/users/{user_id}")
    summary("Get user by id")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :number, "User ID", required: true, example: 1)
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
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

  swagger_path :register do
    post("/api/users")
    summary("Register user")
    produces("application/json")
    deprecated(false)

    parameter(:user, :body, Schema.ref(:UserRequest), "The user details",
      example: %{
        user: %{
          username: "Joe",
          email: "joe@mail.com",
          password: "JoesPassword"
        }
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

  swagger_path :update do
    put("/api/users/{user_id}")
    summary("Update user")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :number, "User ID", required: true, example: 1)

    parameter(:user, :body, Schema.ref(:UserRequest), "The user details",
      example: %{
        user: %{username: "Joe", email: "joe@mail.com"}
      }
    )

    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:UserResponse),
      example: %{
        user: %{
          id: 1,
          username: "Joe Mama",
          email: "joe@mail.com",
          role: "employee",
          team: [
            %{name: "Development"}
          ]
        }
      }
    )
  end

  swagger_path :set_role do
    put("/api/users/set_role/{user_id}")
    summary("Update role from user (administrator only)")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :number, "User ID", required: true, example: 1)

    parameter(:user, :body, Schema.ref(:UserRoleRequest), "The user new role",
      example: %{
        role: "manager"
      }
    )

    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:UserResponse),
      example: %{
        user: %{
          id: 1,
          username: "Joe Mama",
          email: "joe@mail.com",
          role: "manager",
          team: [
            %{name: "Development"}
          ]
        }
      }
    )
  end

  swagger_path :update_password do
    PhoenixSwagger.Path.delete("/api/users/{user_id}")
    summary("update password")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :number, "User ID", required: true, example: 1)
    security([%{Bearer: []}])

    parameter(
      :user,
      :body,
      Schema.ref(:UserPasswordRequest),
      "User input for setting new password",
      example: %{
        username: "Joe",
        current_password: "JoesCurrentPassword",
        new_password: "JoesNewPassword"
      }
    )
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/")
    summary("Delete current user, or any user if administrator")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :number, "User ID", required: false, example: 1)
    security([%{Bearer: []}])

    response(204, "OK")
  end
end
