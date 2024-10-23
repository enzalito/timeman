defmodule Timeman.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do

    create table(:clocks, primary_key: false) do
      add :status, :boolean, default: false, null: false
      add :time, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing), primary_key: true
    end

    create(unique_index(:clocks, [:user_id]))
  end
end
