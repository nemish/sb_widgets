defmodule SbWidgets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SbWidgetsWeb.Telemetry,
      # SbWidgets.Repo,
      {DNSCluster, query: Application.get_env(:sb_widgets, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SbWidgets.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SbWidgets.Finch},
      # Start a worker by calling: SbWidgets.Worker.start_link(arg)
      # {SbWidgets.Worker, arg},
      # Start to serve requests, typically the last entry
      SbWidgetsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SbWidgets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SbWidgetsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
