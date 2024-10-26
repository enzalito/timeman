defmodule TimemanWeb.Plugs.Auth do
  import Plug.Conn
  import Guardian.Plug

  alias Timeman.Account.Guardian

  def init(default), do: default

  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> halt()

      user ->
        conn
        |> assign(:current_user, user)
    end
  end
end
