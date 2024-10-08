defmodule EctoAssoc.Clock do
  use Ecto.Schema
  
  schema "clock" do
    field :time, :utc_datetime
    field :status, :boolean
    belongs_to :user, EctoAssoc.User
  end
end
