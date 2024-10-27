defmodule Timeman.Account.Guardian do
  use Guardian, otp_app: :timeman

  alias Timeman.Account

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  # def subject_for_token(_, _) do
  #   {:error, :reason_for_error}
  # end

  def resource_from_claims(%{"sub" => id}) do
    user = Account.get_user!(String.to_integer(id))
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  # def resource_from_claims(_claims) do
  #   {:error, :reason_for_error}
  # end
end
