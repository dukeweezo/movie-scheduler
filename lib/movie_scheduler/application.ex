defmodule MovieScheduler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MovieSchedulerWeb.Telemetry,
      # Start the Ecto repository
      MovieScheduler.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: MovieScheduler.PubSub},
      # Start Finch
      {Finch, name: MovieScheduler.Finch},
      # Start the Endpoint (http/https)
      MovieSchedulerWeb.Endpoint
      # Start a worker by calling: MovieScheduler.Worker.start_link(arg)
      # {MovieScheduler.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MovieScheduler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MovieSchedulerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
