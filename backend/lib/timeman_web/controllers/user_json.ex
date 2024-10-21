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
  def show(%{user: user}) do
    %{data: data(user)}
  end
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def data(users) when is_list(users) do
    Enum.map(users, &data/1)
  end

  # TODO: gérer les champs vides
  def data(%User{} = user) do

    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      working_time: case user.working_times do
        %Ecto.Association.NotLoaded{} -> nil
        [] -> nil
        WorkingTimeJSON.index(user.working_times)
        working_times when is_list(working_times) -> Enum.map(working_times, &WorkingTimeJSON.data/1)
      end,
      clock: case user.clock do
        %Ecto.Association.NotLoaded{} -> nil
        [] -> nil
        clocks when is_list(clocks) -> Enum.map(clocks, &ClockJSON.data/1)
      end
    }
  end

end
