defmodule Timeman.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timeman.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 14:38:00]
      })
      |> Timeman.Clocks.create_clock()

    clock
  end
end
