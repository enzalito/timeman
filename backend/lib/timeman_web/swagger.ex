defmodule TimemanWeb.Swagger do
  @moduledoc false
  alias PhoenixSwagger.Schema

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Timeman API",
        description: "API Documentation for Timeman"
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          in: "header",
          description: "JWT token must be provided. Example: Bearer {token}"
        }
      }
    }
  end
end
