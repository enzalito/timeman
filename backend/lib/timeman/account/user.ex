defmodule Timeman.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    field(:role, :string, default: "employee")
    many_to_many(:teams, Timeman.TeamContext.Team, join_through: "users_teams")
    has_many(:working_times, Timeman.Work.WorkingTime)
    has_one(:clock, Timeman.Clocks.Clock)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role, :password])
    |> validate_required([:username, :email, :password])
    |> put_password_hash()
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> unique_constraint(:role)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
