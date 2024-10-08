defmodule MyRepo.Migrations.Init do
  use Ecto.Migration

  def up do
    create table("user") do
      add :username, :text, null: false
      add :email, :text, null: false
    end

    create table("clock") do
      add :time, :utc_datetime, null: false
      add :status, :boolean, null: false
      add :user_id, references("user"), null: false
    end

    create table("workingtime") do
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime, null: false
      add :user_id, references("user"), null: false
    end
  end

  def down do
    drop table("user")
    drop table("clock")
    drop table("workingtime")
  end
end
