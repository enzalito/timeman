defmodule Timeman.Repo.Migrations.AddFieldsToWorkingTimes do
  use Ecto.Migration

  def change do
    alter table(:workingtime) do
      add :description, :string
      add :type, :string
    end
  end
end
