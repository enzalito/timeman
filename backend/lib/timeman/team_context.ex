defmodule Timeman.TeamContext do
  @moduledoc """
  The TeamContext context.
  """

  import Ecto.Query, warn: false
  alias Timeman.Repo

  alias Timeman.TeamContext.Team
  alias Timeman.Account.User

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams(%{"name" => name}) do
    from(t in Team,
      where: ilike(t.name, ^"%#{name}%"),
      select: t
    )
    |> Repo.all()
  end

  def list_teams() do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id, %{
        "with_users" => "query",
        "with_working_times" => "query",
        "with_clock" => "query"
      }) do
    query =
      from(t in Team,
        where: t.id == ^id,
        join: ut in "users_teams",
        on: ut.team_id == t.id,
        join: u in User,
        on: u.id == ut.user_id,
        left_join: wt in assoc(u, :working_times),
        left_join: c in assoc(u, :clock),
        preload: [users: {u, working_times: wt, clock: c}],
        select: t
      )

    team = Repo.one!(query)
    team
  end

  def get_team!(id, %{"with_users" => "query", "with_working_times" => "query"}) do
    query =
      from(t in Team,
        where: t.id == ^id,
        join: ut in "users_teams",
        on: ut.team_id == t.id,
        join: u in User,
        on: u.id == ut.user_id,
        left_join: wt in assoc(u, :working_times),
        preload: [users: {u, working_times: wt}],
        select: t
      )

    team = Repo.one!(query)
    team
  end

  def get_team!(id, %{"with_users" => "query", "with_clock" => "query"}) do
    team =
      Repo.get!(Team, id)
      |> Repo.preload(users: [:clock])

    team
  end

  def get_team!(id, %{"with_users" => "query"}) do
    team =
      Repo.get!(Team, id)
      |> Repo.preload(:users)

    team
  end

  def get_team!(id, %{}) when is_integer(id) do
    team = Repo.get!(Team, id)
    team
  end

  # TODO: Résoudre doublon get_team_by_id!
  def get_team_by_id!(id) do
    team = Repo.get!(Team, id)
    team
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end
end
