defmodule TimemanWeb.RoleAuthorizationPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, roles) when is_list(roles) do
    user = conn.assigns[:current_user]
    IO.inspect(user, label: "user")

    if has_required_role?(user, roles) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{
        error: "Accès non autorisé",
        message: "Cette action nécessite un des rôles suivants : #{Enum.join(roles, ", ")}"
      })
      |> halt()
    end
  end

  defp has_required_role?(user, allowed_roles) do
    Enum.member?(allowed_roles, user.role)
  end
end
