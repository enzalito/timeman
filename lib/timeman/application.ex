defmodule Timeman.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimemanWeb.Telemetry,
      Timeman.Repo,
      {DNSCluster, query: Application.get_env(:timeman, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Timeman.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Timeman.Finch},
      # Start a worker by calling: Timeman.Worker.start_link(arg)
      # {Timeman.Worker, arg},
      # Start to serve requests, typically the last entry
      TimemanWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Timeman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimemanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
