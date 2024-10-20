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

  def show(%{team: team, members: members}) do
    %{data: data(team, members)}
  end
  def show(%{team: team}) do
    %{data: data(team, [])}
  end

  defp data(%Team{} = team, members \\ []) do
    %{
      id: team.id,
      name: team.name,
      members: UserJSON.data(members)
    }
  end
end
