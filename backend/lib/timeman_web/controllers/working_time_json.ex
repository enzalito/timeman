defmodule TimemanWeb.WorkingTimeJSON do
  alias Timeman.Work.WorkingTime

  @doc """
  Renders a list of workingtime.
  """
  def index(%{workingtime: workingtime}) do
    %{data: for(working_time <- workingtime, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  def data(working_times) when is_list(working_times) do
    Enum.map(working_times, fn working_time ->
      %{
        id: working_time.id,
        start: working_time.start,
        end: working_time.end,
        description: working_time.description,
        period: working_time.period
      }
    end)
  end

  def data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      user_id: working_time.user_id,
      description: working_time.description,
      period: working_time.period
    }
  end

end
