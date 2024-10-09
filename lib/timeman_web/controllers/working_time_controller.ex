defmodule TimemanWeb.WorkingTimeController do
  use TimemanWeb, :controller

  alias Timeman.Work
  alias Timeman.Work.WorkingTime

  action_fallback TimemanWeb.FallbackController

  def index(conn, _params) do
    workingtime = Work.list_workingtime()
    render(conn, :index, workingtime: workingtime)
  end

  # def create(conn, %{"userId" => userId, "working_time" => working_time_params}) do
  #   with {:ok, %WorkingTime{} = working_time} <- Work.create_working_time(working_time_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/workingtime/#{working_time}")
  #     |> render(:show, working_time: working_time)
  #   end
  # end

  def createWithUserRelation(conn, %{"userId" => userId, "working_time" => working_time_params}) do
    IO.inspect(userId, label: "userId")

    workingTimeObject = Map.put(working_time_params, "user", userId)
    IO.inspect(workingTimeObject, label: "workingTimeObject")

    with {:ok, %WorkingTime{} = workingTime} <-
           Work.create_working_time(workingTimeObject) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{userId}")
      |> render(:show, working_time: workingTime)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <-
           Work.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Work.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
