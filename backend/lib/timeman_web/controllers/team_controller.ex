defmodule TimemanWeb.TeamController do
  use TimemanWeb, :controller
  use PhoenixSwagger

  alias Timeman.Account

  alias Timeman.Account.User

  alias Timeman.TeamContext
  alias Timeman.TeamContext.Team
  alias Timeman.Repo
  import Ecto.Query

  action_fallback(TimemanWeb.FallbackController)

  def index(conn, %{"name" => name} = params) do
    teams = TeamContext.list_teams(%{"name" => name})
    render(conn, :index, teams: teams)
  end

  def index(conn, _param) do
    teams = TeamContext.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- TeamContext.create_team(team_params) do
      conn
      |> put_status(:created)
      |> render(:show, team: team)
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id} = params) do
    team_id = String.to_integer(id)

    check_key = fn key ->
      if Map.has_key?(params, key), do: "query", else: nil
    end

    query_params = %{
      "with_users" => check_key.("with_users"),
      "with_working_times" => check_key.("with_working_times"),
      "with_clock" => check_key.("with_clock")
    }

    team = TeamContext.get_team!(team_id, query_params)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = TeamContext.get_team_by_id!(id)

    with {:ok, %Team{} = team} <- TeamContext.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = TeamContext.get_team_by_id!(id)

    with {:ok, %Team{}} <- TeamContext.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  def add_team(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    user =
      Repo.get!(User, user_id)
      |> Repo.preload(:teams)

    team = Repo.get!(Team, team_id)

    changeset =
      user
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:teams, [team | user.teams])

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_status(:ok)
        |> send_resp(:ok, "")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> send_resp(:unprocessable_entity, "")
    end
  end

  def remove_team(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    # TODO: set les query en integer  et bouger la logique dans le contexte
    user_id = String.to_integer(user_id)
    team_id = String.to_integer(team_id)

    user =
      Repo.get!(User, user_id)
      |> Repo.preload(:teams)

    team = Repo.get!(Team, team_id)

    if team in user.teams do
      Repo.delete_all(
        from(ut in "users_teams",
          where: ut.user_id == ^user_id and ut.team_id == ^team_id
        )
      )

      conn
      |> put_status(:ok)
      |> send_resp(:ok, "")
    else
      conn
      |> put_status(:unprocessable_entity)
      |> send_resp(:unprocessable_entity, "")
    end
  end

  def swagger_definitions do
    %{
      TeamRequest:
        swagger_schema do
          title("TeamRequest")
          description("POST body for creating a team")

          property(
            :team,
            %Schema{
              properties: %{
                name: %{type: :string, description: "Team name", required: true}
              },
              example: %{
                name: "Marketing"
              }
            },
            "The team details"
          )
        end,
      TeamResponse:
        swagger_schema do
          title("TeamResponse")
          description("Response schema for single team")

          property(
            :data,
            %Schema{
              properties: %{
                name: %{type: :string, description: "Team name", required: true}
              },
              example: %{
                id: 1,
                name: "Marketing"
              }
            },
            "The team details"
          )
        end
    }
  end

  swagger_path :index do
    get("/api/teams")
    summary("Get all teams with fuzzy search (manager and administrator)")
    produces("application/json")
    deprecated(false)
    parameter(:name, :query, :string, "fuzzy name search", required: false, example: "Ma")
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:TeamResponse),
      example: %{
        data: %{
          id: 1,
          name: "Marketing"
        }
      }
    )
  end

  # TODO: spécifier les 3 exemples possibles
  swagger_path :show do
    get("/api/teams/{team_id}")
    summary("Get team by id  (manager and administrator)")
    produces("application/json")
    deprecated(false)
    parameter(:team_id, :path, :number, "Team ID", required: true, example: 1)
    parameter(:with_users, :query, :boolean, "With users", required: false, example: "")
    security([%{Bearer: []}])

    parameter(:with_working_times, :query, :boolean, "With working times",
      required: false,
      example: ""
    )

    parameter(:with_clock, :query, :boolean, "With clock", required: false, example: "")

    response(200, "OK", Schema.ref(:TeamResponse),
      example: %{
        data: %{
          id: 1,
          name: "Marketing"
        }
      }
    )
  end

  swagger_path :create do
    post("/api/teams")
    summary("Create team (manager and administrator)")
    produces("application/json")
    deprecated(false)
    security([%{Bearer: []}])

    parameter(:name, :body, Schema.ref(:TeamRequest), "The team details",
      example: %{
        name: "Marketing"
      }
    )

    response(201, "OK", Schema.ref(:TeamResponse),
      example: %{
        data: %{
          id: 1,
          name: "Marketing"
        }
      }
    )
  end

  swagger_path :update do
    put("/api/teams/{team_id}")
    summary("Update team (manager and administrator)")
    produces("application/json")
    deprecated(false)
    parameter(:team_id, :path, :number, "User ID", required: true, example: 1)
    security([%{Bearer: []}])

    parameter(:user, :body, Schema.ref(:TeamRequest), "The team details",
      example: %{
        Team: %{name: "Developper"}
      }
    )

    response(200, "OK", Schema.ref(:TeamResponse),
      example: %{
        data: %{
          id: 1,
          name: "Marketing"
        }
      }
    )
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/teams/{user_id}")
    summary("Delete team (manager and administrator)")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :number, "User ID", required: true, example: 1)
    security([%{Bearer: []}])

    response(204, "OK")
  end

  swagger_path :add_team do
    post("/api/teams/{team_id}/user/{user_id}")
    summary("Add a team to a user  (manager and administrator)")
    description("Associates a team to a user.")
    produces("application/json")

    parameter(:team_id, :path, :integer, "The ID of the team", required: true, example: 1)
    parameter(:user_id, :path, :integer, "The ID of the user", required: true, example: 1)
    security([%{Bearer: []}])

    response(200, "OK")
  end

  swagger_path :remove_team do
    PhoenixSwagger.Path.delete("/api/teams/{team_id}/user/{user_id}")
    summary("Remove a team from a user (manager and administrator)")
    description("Removes a team from a user.")
    produces("application/json")

    parameter(:user_id, :path, :integer, "The ID of the user", required: true, example: 1)
    security([%{Bearer: []}])

    parameter(:team_id, :path, :integer, "The ID of the team to be removed",
      required: true,
      example: 1
    )

    response(200, "OK")
  end
end
