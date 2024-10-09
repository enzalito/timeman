defmodule Timeman.Work.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]  # Assurez-vous d'importer la macro from

  schema "workingtime" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user, :id

    timestamps(type: :utc_datetime)
  end



  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
  end


end
