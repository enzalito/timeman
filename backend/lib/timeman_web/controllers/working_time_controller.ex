defmodule TimemanWeb.WorkingTimeController do
  use TimemanWeb, :controller
  use PhoenixSwagger

  alias Timeman.Work
  alias Timeman.Work.WorkingTime

  action_fallback TimemanWeb.FallbackController

  # def create(conn, %{"userId" => userId, "working_time" => working_time_params}) do
  #   with {:ok, %WorkingTime{} = working_time} <- Work.create_working_time(working_time_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/workingtime/#{working_time}")
  #     |> render(:show, working_time: working_time)
  #   end
  # end

  def createWithUserRelation(conn, %{"user_id" => user_id, "working_time" => working_time}) do
    working_time = Map.put(working_time, "user_id", user_id)
    with {:ok, %WorkingTime{} = res} <-
           Work.create_working_time(working_time) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{res.user_id}")
      |> render(:show, working_time: res)
    end
  end

  def getWorkingTime(conn, %{"user_id" => user_id, "id" => id}) do
    working_time_by_user = Work.get_working_time_by_Id_UserId!(user_id)

    result = Enum.find(working_time_by_user, fn wt -> wt.id == String.to_integer(id) end)

    cond do
      is_nil(result) ->
        json(conn, %{data: []})
        |> put_status(:bad_request)

      true ->
        render(conn, :show, working_time: result)
    end
  end

  def showTimeForOneUser(conn, params) do
    # Accessing the path parameter
    user_id = params["user_id"]

    # Accessing query parameters
    start = Map.get(params, "start")
    end_time = Map.get(params, "end")

    working_time = Work.get_working_time_for_user!(user_id, start, end_time)
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

  # TODO: Rectifier swagger pour nouveau schéma, est-ce qu'on affiche l'id ?
  def swagger_definitions do
    %{
      WorkingTimeRequest:
        swagger_schema do
          title("WorkingTimeRequest")
          description("POST body for creating a WorkingTime")

          property(
            :working_time,
            %Schema{
              properties: %{
                start: %{type: :string, description: "start of the period", required: true},
                end: %{
                  type: :string,
                  description: "end of the period",
                  format: :email,
                  required: true
                }
              },
              example: %{
                start: "2024-07-29 12:28:29",
                end: "2024-08-30 12:28:29",
              }
            },
            "The working time details"
          )
        end,
      WorkingTimeResponse:
        swagger_schema do
          title("WorkingTimeResponse")
          description("Response schema for WorkingTime user")

          property(
            :data,
            %Schema{
              properties: %{
                start: %{type: :string, description: "start of the period", required: true},
                end: %{
                  type: :number,
                  description: "end of the period",
                  format: :email,
                  required: true
                },
                user_id: %{
                  type: :number,
                  description: "user id",
                  required: true
                }
              },
              example: %{
                id: 1,
                user_id: 1,
                start: "2024-07-29 12:28:29",
                end: "2024-08-30 12:28:29",
              }
            },
            "The working details details"
          )
        end
    }
  end

  swagger_path :getWorkingTime do
    get("/api/workingtime/{user_id}/{id}")
    summary("Get working time by user_id and id")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :string, "user id", example: "1")
    parameter(:id, :path, :string, "id", example: "1")

    response(200, "OK", Schema.ref(:WorkingTimeResponse),
      example: %{
        data: %{
          id: 1,
          user_id: 1,
          start: "2024-07-29 12:28:29",
          end: "2024-08-30 12:28:29"
        }
      }
    )
  end

  swagger_path :showTimeForOneUser do
    get("/api/workingtime/{user_id}")
    summary("Show working times for a specific user within specified ")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :string, "User ID", required: true, example: 1)
    parameter(:start, :query, :string, "start time",
      required: false,
      example: "2024-07-29T12:28:29"
    )
    parameter(:end, :query, :string, "end time", required: false, example: "2024-08-30T12:28:29")

    response(200, "OK", Schema.ref(:WorkingTimeResponse),
      example: %{
        data: %{
          user_id: 1,
          id: 1,
          start: "2024-07-29 12:28:29",
          end: "2024-08-30 12:28:29"
        }
      }
    )
  end

  swagger_path :createWithUserRelation do
    post("/api/workingtime/{user_id}")
    summary("Create working time")
    produces("application/json")
    deprecated(false)

    parameter(:user_id, :path, :string, "user id", required: true, example: 1)

    parameter(:working_time, :body, Schema.ref(:WorkingTimeRequest), "The user details",
      example: %{
        working_time: %{start: "2024-07-29 12:28:29", end: "2024-08-30 12:28:29"}
      }
    )

    response(201, "OK", Schema.ref(:WorkingTimeResponse),
      example: %{
        data: %{
          user_id: 1,
          id: 1,
          start: "2024-07-29T12:28:29",
          end: "2024-08-30T12:28:29"
        }
      }
    )
  end

  swagger_path :update do
    put("/api/workingtime/{id}")
    summary("Update working time")
    produces("application/json")
    deprecated(false)
    parameter(:id, :path, :number, "working time id", required: true, example: 1)

    parameter(:working_time, :body, Schema.ref(:WorkingTimeRequest), "The user details",
      example: %{
        working_time: %{start: "2024-07-29 12:28:29", end: "2024-08-30 12:28:29"}
      }
    )

    response(200, "OK", Schema.ref(:WorkingTimeResponse),
      example: %{
        data: %{
          user_id: 1,
          id: 1,
          start: "2024-07-29T12:28:29",
          end: "2024-08-30T12:28:29"
        }
      }
    )
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/workingtime/{id}")
    summary("Delete working time")
    produces("application/json")
    deprecated(false)
    parameter(:id, :path, :number, "working time id", required: true, example: 1)

    response(204, "OK")
  end
end
