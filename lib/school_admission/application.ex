defmodule SchoolAdmission.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SchoolAdmissionWeb.Telemetry,
      # Start the Ecto repository
      SchoolAdmission.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SchoolAdmission.PubSub},
      # Start Finch
      {Finch, name: SchoolAdmission.Finch},
      # Start the Endpoint (http/https)
      SchoolAdmissionWeb.Endpoint
      # Start a worker by calling: SchoolAdmission.Worker.start_link(arg)
      # {SchoolAdmission.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SchoolAdmission.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SchoolAdmissionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
