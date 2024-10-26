defmodule TimemanWeb.ClockController do
  use TimemanWeb, :controller
  use PhoenixSwagger

  alias Timeman.Clocks
  alias Timeman.Clocks.Clock

  action_fallback(TimemanWeb.FallbackController)

  def clocks_by_user(conn, %{"user_id" => user_id}) do
    clocks = Clocks.list_clocks_from_user(user_id)
    render(conn, "index.json", clocks: clocks)
  end

  def upsert_clock(conn, %{"user_id" => user_id, "clock" => clock}) do
    clock = Map.put(clock, "user_id", user_id)
    status = Map.get(clock, "status")

    if status == false do
      Clocks.create_working_time(clock)
    end

    clock = Clocks.create_or_update_clock(clock)
    render(conn, :show, clock: clock)
  end

  def swagger_definitions do
    %{
      ClockRequest:
        swagger_schema do
          title("ClockRequest")
          description("POST body for creating clocks")

          property(
            :clock,
            %Schema{
              properties: %{
                status: %{
                  type: :boolean,
                  description: "Status of the clock (true when click'in)",
                  default: true,
                  required: true
                },
                time: %{type: :string, description: "Timestamp of the clock", required: true}
              },
              example: %{
                status: "true",
                time: "2024-10-08T14:30:00"
              }
            },
            "The clock details"
          )
        end,
      ClockResponse:
        swagger_schema do
          title("ClockResponse")
          description("Response schema for clocks corresponding to one user")

          property(
            :data,
            %Schema{
              properties: %{
                status: %{type: :boolean, description: "Status", required: true},
                time: %{type: :string, description: "Timestamp of the clock", required: true},
                user_id: %{type: :number, description: "ID", required: true}
              },
              example: %{
                status: true,
                time: "2024-10-08T14:30:00",
                user_id: 1
              }
            },
            "The user details"
          )
        end
    }
  end

  swagger_path :clocks_by_user do
    get("/api/clocks/{user_id}")
    summary("Get clocks by user ID")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :integer, "User ID", required: true)
    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:ClockResponse),
      example: %{
        data: %{
          status: true,
          time: "2024-10-08T14:45:00"
        }
      }
    )
  end

  swagger_path :upsert_clock do
    post("/api/clocks/{user_id}")
    summary("Create or update user's clock. If status false, create a new working time.")
    produces("application/json")
    deprecated(false)
    parameter(:user_id, :path, :integer, "User ID", required: true, example: 1)
    security([%{Bearer: []}])

    parameter(:clock, :body, Schema.ref(:ClockRequest), "The clock details",
      example: %{
        clock: %{
          status: true,
          time: "2025-10-08T14:45:00"
        }
      }
    )

    response(201, "OK", Schema.ref(:ClockResponse),
      example: %{
        data: %{
          status: true,
          time: "2024-10-08T14:45:00",
          user_id: 3
        }
      }
    )
  end
end
