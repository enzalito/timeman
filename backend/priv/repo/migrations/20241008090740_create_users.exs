defmodule Timeman.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :role, :string
    end
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
