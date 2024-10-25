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

    working_times =
      if Ecto.assoc_loaded?(user.working_times) do
        case user.working_times do
          [] ->
            nil

          wt when is_list(wt) ->
            Enum.map(wt, &WorkingTimeJSON.data/1)
        end
      end

    clock =
      if Ecto.assoc_loaded?(user.clock) do
        case user.clock do
          nil -> nil
          c -> ClockJSON.data(c)
        end
      end

    case {Ecto.assoc_loaded?(user.working_times), Ecto.assoc_loaded?(user.clock)} do
      {true, true} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams),
          working_time: working_times,
          clock: clock,
          password: user.password
        }

      {true, false} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams),
          working_time: working_times,
          password: user.password
        }

      {false, true} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams),
          clock: clock,
          password: user.password
        }

      {false, false} ->
        %{
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          teams: render_teams(user.teams),
          password: user.password
        }
    end
  end
end
