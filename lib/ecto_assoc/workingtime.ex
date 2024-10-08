defmodule EctoAssoc.WorkingTime do
  use Ecto.Schema
  
  schema "workingtime" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, EctoAssoc.User
  end
end
