defmodule Timeman.Clocks do
  @moduledoc """
  The Clocks context.
  """

  import Ecto.Query, warn: false
  alias Timeman.Repo

  alias Timeman.Clocks.Clock

  alias Timeman.Work

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def create_or_update_clock(attrs \\ %{}) do
    changeset = Clock.changeset(%Clock{}, attrs)

    Repo.insert!(
      changeset,
      on_conflict: :replace_all,
      conflict_target: [:user_id]
    )
  end

  def create_working_time(clock) do
    user_id = String.to_integer(Map.get(clock, "user_id"))

    description = Map.get(clock, "description")

    query =
      from(c in Clock,
        where: c.user_id == ^user_id,
        select: c
      )

    old_clock = Repo.one(query)
    start_time = old_clock.time
    end_time = Map.get(clock, "time")
    {:ok, end_time} = NaiveDateTime.from_iso8601(end_time)

    working_time = %{
      start: start_time,
      end: end_time,
      description: description,
      user_id: user_id
    }

    add_working_time(working_time)
  end

  defp add_working_time(working_time) do
    start_time = working_time.start
    end_time = working_time.end
    wt1 = working_time
    wt2 = working_time
    wt3 = working_time

    cond do
      start_time.hour < 6 && end_time.hour >= 6 && start_time.day == end_time.day ->
        new_end_time = %NaiveDateTime{end_time | hour: 5, minute: 59}
        wt1 = %{working_time | end: new_end_time}

        new_start_time = %NaiveDateTime{start_time | hour: 6, minute: 00}
        wt2 = %{working_time | start: new_start_time}
        Work.create_working_time(wt1)
        add_working_time(wt2)

      end_time.hour >= 22 && start_time.hour < 22 && start_time.day == end_time.day ->
        new_end_time = %NaiveDateTime{end_time | hour: 21, minute: 59}
        wt1 = %{working_time | end: new_end_time}

        new_start_time = %NaiveDateTime{start_time | hour: 22, minute: 00}
        wt2 = %{working_time | start: new_start_time}

        Work.create_working_time(wt1)
        add_working_time(wt2)

      start_time.hour < 6 && start_time.day != end_time.day ->
        new_end_time = %NaiveDateTime{end_time | hour: 5, minute: 59}
        wt1 = %{working_time | end: new_end_time}

        new_start_time = %NaiveDateTime{start_time | hour: 6, minute: 00}
        wt2_end_time = %NaiveDateTime{start_time | hour: 23, minute: 59}
        wt2 = %{working_time | start: new_start_time, end: wt2_end_time}

        wt3_start_time = %NaiveDateTime{start_time | hour: 0, minute: 0}

        wt3_start_time =
          NaiveDateTime.add(start_time, 1 * 86_400) |> Map.put(:hour, 0) |> Map.put(:minute, 0)

        wt3 = %{working_time | start: wt3_start_time}

        Work.create_working_time(wt1)
        add_working_time(wt2)
        add_working_time(wt3)

      start_time.hour < 22 && start_time.day != end_time.day ->
        new_end_time = %NaiveDateTime{end_time | hour: 21, minute: 59}
        wt1 = %{working_time | end: new_end_time}

        new_start_time = %NaiveDateTime{start_time | hour: 22, minute: 00}
        wt2_end_time = %NaiveDateTime{start_time | hour: 23, minute: 59}
        wt2 = %{working_time | start: new_start_time, end: wt2_end_time}

        wt3_start_time =
          NaiveDateTime.add(start_time, 1 * 86_400) |> Map.put(:hour, 0) |> Map.put(:minute, 0)

        wt3 = %{working_time | start: wt3_start_time}

        Work.create_working_time(wt1)
        Work.create_working_time(wt2)
        add_working_time(wt3)

      true ->
        Work.create_working_time(working_time)
        :ok
    end
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  def list_clocks_from_user(user_id) do
    Repo.all(from(c in Clock, where: c.user_id == ^user_id))
  end
end
