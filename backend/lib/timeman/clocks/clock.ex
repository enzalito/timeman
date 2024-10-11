defmodule Timeman.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: true
    field :time, :naive_datetime
    field :user_id, :id
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :time, :user_id])
    |> validate_required([:status, :time, :user_id])
  end

end
