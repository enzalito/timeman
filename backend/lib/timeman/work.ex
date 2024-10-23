defmodule Timeman.Work do
  @moduledoc """
  The Work context.
  """

  import Ecto.Query, warn: false
  alias Timeman.Repo
  alias Timeman.Work.WorkingTime

  @doc """
  Returns the list of workingtime.

  ## Examples

      iex> list_workingtime()
      [%WorkingTime{}, ...]

  """
  def list_workingtime do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def get_working_time_by_Id_UserId!(user_id) do
    Repo.all(from(w in WorkingTime, where: w.user_id == ^user_id))
  end

  def get_working_time_for_user!(user_id, start_time, end_time)
      when is_nil(end_time) and is_nil(start_time) do
    query =
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id,
        select: wt
      )

    Repo.all(query)
  end

  def get_working_time_for_user!(user_id, start_time, end_time) when is_nil(end_time) do
    query =
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_time,
        select: wt
      )

    Repo.all(query)
  end

  def get_working_time_for_user!(user_id, start_time, end_time) when is_nil(start_time) do
    query =
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.end >= ^end_time,
        select: wt
      )

    Repo.all(query)
  end

  def get_working_time_for_user!(user_id, start_time, end_time) do
    query =
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_time and wt.end <= ^end_time,
        select: wt
      )

    Repo.all(query)
  end

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    IO.inspect(attrs, label: "in create")
    result = get_period(attrs)

    %WorkingTime{}
    |> WorkingTime.changeset(result)
    |> Repo.insert()
  end

  def get_period(attrs) do
    IO.inspect(attrs, label: "attrs")

    start_time = Map.get(attrs, :start)
    IO.inspect(start_time)
    end_time = Map.get(attrs, :end)
    start_hour = start_time.hour
    end_hour = end_time.hour

    period =
      if start_hour >= 6 && end_hour < 22 do
        "day"
      else
        "night"
      end

    Map.put(attrs, :period, period)
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
