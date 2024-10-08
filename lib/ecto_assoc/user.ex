defmodule EctoAssoc.User do
  use Ecto.Schema
  
  schema "user" do
    field :username, :string
    field :email, :string
    has_many :clock, EctoAssoc.Clock
    has_many :workingtime, EctoAssoc.WorkingTime
  end
end
