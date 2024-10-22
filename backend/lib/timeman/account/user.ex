defmodule Timeman.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :role, :string, default: "employee"
    many_to_many :teams, Timeman.TeamContext.Team, join_through: "users_teams"
    has_many :working_times, Timeman.Work.WorkingTime
    has_many :clock, Timeman.Clocks.Clock
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role])
    |> validate_required([:username, :email])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> unique_constraint(:role)
  end
end
