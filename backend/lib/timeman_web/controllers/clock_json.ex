defmodule TimemanWeb.ClockJSON do
  alias Timeman.Clocks.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clock <- clocks, do: data(clock))}
  end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  def data(%Clock{} = clock) do
    %{
      time: clock.time,
      status: clock.status,
      user_id: clock.user_id
    }
  end
end
