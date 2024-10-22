defmodule TimemanWeb.UserController do
  use TimemanWeb, :controller
  use PhoenixSwagger

  alias Timeman.Account
  alias Timeman.Account.User


  action_fallback TimemanWeb.FallbackController

  def index(conn, %{"username" => username}) do
    user = Account.list_users(%{"username" => username})
    render(conn, :show, user: user)
  end
  def index(conn, _param) do
    user = Account.list_users()
    render(conn, :show, user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
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

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def set_role(conn, %{"id" => id,"user" => %{"role" => role}}) do
    user = Account.get_user!(String.to_integer(id))

    changeset = User.changeset(user, %{"role" => role})
    with {:ok, %User{} = user} <- Account.update_user(user, %{"role" => role}) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(String.to_integer(id))

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
    %{
      UserRequest:
        swagger_schema do
          title "UserRequest"
          description "POST body for creating a user"
          property :user,
            %Schema{
              properties: %{
                username: %{type: :string, description: "User name", required: true},
                email: %{type: :string, description: "Email address", format: :email, required: true},
              },
              example: %{
                username: "Joe",
                email: "joe@mail.com",
              }
            },
            "The user details"
        end,
      UserResponse:
        swagger_schema do
          title "UserResponse"
          description "Response schema for single user"
          property :data,
            %Schema{
              properties: %{
                id: %{type: :string, description: "ID", required: true},
                username: %{type: :string, description: "User name", required: true},
                email: %{type: :string, description: "Email address", format: :email, required: true},
                role: %{type: :string, description: "User Role", required: false},
              },
              example: %{
                id: 1,
                username: "Joe",
                email: "joe@mail.com",
                role: "employee",
              }
            },
            "The user details"
        end,
        UserRoleRequest:
          swagger_schema do
            title "UserRoleRequest"
            description "request schema to set new role"
            property :user,
              %Schema{
                properties: %{
                  role: %{type: :string, description: "role", required: true}
              },
              example: %{
                role: "manager"
                }
            },
          "The user role"
          end
    }
  end

  swagger_path :index do
    get "/api/users"
    summary "Get all users with fuzzy search"
    produces "application/json"
    deprecated false
    parameter :username, :query, :string, "fuzzy name search", required: false, example: "Jo"

    response 200, "OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 1,
          username: "Joe",
          email: "joe@mail.com",
          role: "employee",
        }
      }
  end


  swagger_path :show do
    get "/api/users/{user_id}"
    summary "Get user by id"
    produces "application/json"
    deprecated false
    parameter :user_id, :path, :number, "User ID", required: true, example: 1

    response 200, "OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 1,
          username: "Joe",
          email: "joe@mail.com",
          role: "employee",
        }
      }
  end

  swagger_path :create do
    post "/api/users"
    summary "Create user"
    produces "application/json"
    deprecated false
    parameter :user, :body, Schema.ref(:UserRequest), "The user details",
      example: %{
        user: %{username: "Joe", email: "joe@mail.com"}
      }

    response 201, "OK", Schema.ref(:UserResponse),
      example: %{
        user: %{
          id: 1,
          username: "Joe",
          email: "joe@mail.com",
          role: "employee",
        }
      }
  end

  swagger_path :update do
    put "/api/users/{user_id}"
    summary "Update user"
    produces "application/json"
    deprecated false
    parameter :user_id, :path, :number, "User ID", required: true, example: 1
    parameter :user, :body, Schema.ref(:UserRequest), "The user details",
      example: %{
        user: %{username: "Joe", email: "joe@mail.com"}
      }

    response 200, "OK", Schema.ref(:UserResponse),
      example: %{
        user: %{
          id: 1,
          username: "Joe Mama",
          email: "joe@mail.com",
          role: "employee",
        }
      }
  end
  swagger_path :set_role do
    put "/api/users/set_role/{user_id}"
    summary "Update role from user"
    produces "application/json"
    deprecated false
    parameter :user_id, :path, :number, "User ID", required: true, example: 1
    parameter :user, :body, Schema.ref(:UserRoleRequest), "The user new role",
      example: %{
        role: "manager"
      }

    response 200, "OK", Schema.ref(:UserResponse),
      example: %{
        user: %{
          id: 1,
          username: "Joe Mama",
          email: "joe@mail.com",
          role: "manager",
        }
      }
  end
  swagger_path :delete do
    PhoenixSwagger.Path.delete "/api/users/{user_id}"
    summary "Delete user"
    produces "application/json"
    deprecated false
    parameter :user_id, :path, :number, "User ID", required: true, example: 1

    response 204, "OK"
  end
end
