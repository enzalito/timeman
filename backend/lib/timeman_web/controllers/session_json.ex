defmodule TimemanWeb.SessionJSON do
  use TimemanWeb, :controller
  alias Timeman.Account.User

  def render("token.json", %{token: token}) do
    %{
      token: token
    }
  end
end
