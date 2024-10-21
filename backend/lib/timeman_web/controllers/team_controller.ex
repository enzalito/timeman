defmodule TimemanWeb.TeamController do
  use TimemanWeb, :controller

  alias Timeman.TeamContext
  alias Timeman.TeamContext.Team

  action_fallback TimemanWeb.FallbackController

  def index(conn, %{"name" => name} = params) do
    teams = TeamContext.list_teams(%{"name" => name})
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- TeamContext.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  #TODO : vérifier si c'est nécessaire la double fonction
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id} = params) do
    team_id = String.to_integer(id)

    check_key = fn key ->
      if Map.has_key?(params, key), do: "query", else: nil
    end

    query_params = %{
    "with_users" => check_key.("with_users"),
    "with_workingtimes" => check_key.("with_workingtimes"),
    "with_clock" => check_key.("with_clock")
    }

    team = TeamContext.get_team!(team_id, query_params)
    render(conn, :show, team: team)
  end

  # def show(conn, %{"id" => id}) do
  #   team = TeamContext.get_team!(id)
  #   render(conn, :show, team: team)
  # end


  def update(conn, %{"id" => id, "team" => team_params}) do
    team = TeamContext.get_team!(id)

    with {:ok, %Team{} = team} <- TeamContext.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = TeamContext.get_team!(id)

    with {:ok, %Team{}} <- TeamContext.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
