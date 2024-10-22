defmodule Timeman.Repo.Migrations.CreateWorkingtime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :description, :string
      add :period, :string
    end

    create index(:workingtime, [:user_id])
  end
end
