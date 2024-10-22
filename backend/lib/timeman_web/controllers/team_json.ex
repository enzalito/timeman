defmodule TimemanWeb.TeamJSON do
  alias Timeman.TeamContext.Team
  alias TimemanWeb.UserJSON

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """


  def show(%{team: team}) do
    %{data: data(team)}
  end

  defp data(%Team{} = team) do

    if Ecto.assoc_loaded?(team.users) do
      %{
        id: team.id,
        name: team.name,
        users: case team.users do
          %Ecto.Association.NotLoaded{} -> nil
          [] -> nil
          users -> UserJSON.data(users)
        end
      }
    else
      %{
        id: team.id,
        name: team.name
      }

    end


  end
end
