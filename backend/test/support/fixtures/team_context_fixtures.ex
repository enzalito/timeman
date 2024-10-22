defmodule Timeman.TeamContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timeman.TeamContext` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Timeman.TeamContext.create_team()

    team
  end
end
