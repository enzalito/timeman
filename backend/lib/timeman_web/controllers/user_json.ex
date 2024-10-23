defmodule TimemanWeb.UserJSON do
  alias Timeman.Account.User
  alias TimemanWeb.WorkingTimeJSON
  alias TimemanWeb.ClockJSON

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  defp render_teams(teams) do
    if Ecto.assoc_loaded?(teams) do
      Enum.map(teams, fn team ->
        %{
          id: team.id,
          name: team.name
        }
      end)
    else
      []
  end
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  def data(users) when is_list(users) do
    Enum.map(users, &data/1)
  end

  def data(%User{} = user) do

    # TODO: Revoir syntaxe

    working_time =
      if Ecto.assoc_loaded?(user.working_times) do
      %{
      working_time: case user.working_times do
        [] -> nil
        working_times when is_list(working_times) -> Enum.map(working_times, &WorkingTimeJSON.data/1)
      end
    }
    end

    clock =
      if Ecto.assoc_loaded?(user.clock) do
        %{
      clock: case user.clock do
        [] -> nil
        clocks when is_list(clocks) -> Enum.map(clocks, &ClockJSON.data/1)
      end
    }
  end

    case {Ecto.assoc_loaded?(user.working_times), Ecto.assoc_loaded?(user.clock)} do
      {true, true} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams),
          working_time: working_time,
          clock: clock
        }
      {true, false} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams),
          working_time: working_time,
        }
      {false, true} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams),
          clock: clock
        }
      {false, false} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams)
        }

    end

    end

end
