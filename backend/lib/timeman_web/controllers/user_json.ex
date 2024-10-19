defmodule TimemanWeb.UserJSON do
  alias Timeman.Account.User

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

  defp data(users) when is_list(users) do
    Enum.map(users, &data/1)
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      type: user.type
    }
  end
end
