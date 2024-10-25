defmodule TimemanWeb.SessionController do
  use TimemanWeb, :controller

  alias Timeman.{Account, Account.User, Account.Guardian}

  # def new(conn, _) do
  #   changeset = Account.change_user(%User{})
  #   maybe_user = Guardian.Plug.current_resource(conn)

  #   if maybe_user do
  #     redirect(conn, to: "/protected")
  #   else
  #     render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
  #   end
  # end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    with {:ok, user} <- Account.authenticate_user(username, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> json(%{message: "Login successful", token: token})
    else
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials", reason: reason})
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> json(%{message: "Logout successful"})
  end

  # docs are not applicable here

  # defp login_reply({:ok, user}, conn) do
  #   conn
  #   |> put_flash(:info, "Welcome back!")
  #   # This module's full name is Auth.Account.Guardian.Plug,
  #   |> Guardian.Plug.sign_in(user)
  #   # and the arguments specified in the Guardian.Plug.sign_in()
  #   |> redirect(to: "/protected")
  # end

  # docs are not applicable here.

  # defp login_reply({:error, reason}, conn) do
  #   conn
  #   |> put_flash(:error, to_string(reason))
  #   |> new(%{})
  # end
end
