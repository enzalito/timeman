defmodule TimemanWeb.ClockController do
  use TimemanWeb, :controller

  alias Timeman.Clocks
  alias Timeman.Clocks.Clock

  action_fallback TimemanWeb.FallbackController

  def clocks_by_user(conn, %{"user_id" => user_id}) do
    clocks = Clocks.list_clocks_from_user(user_id)
    render(conn, "index.json", clocks: clocks)
  end
  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create_clock_for_user(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", user_id)

    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{user_id}")
      |> render(:show, clock: clock)
    end
  end

end
