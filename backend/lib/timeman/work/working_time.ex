defmodule Timeman.Work.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :description, :string
    field :type, :string
    belongs_to :user, Timeman.Account.User

  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id, :description, :type])
    |> validate_required([:start, :end, :user_id])
  end
end
