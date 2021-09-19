defmodule NurseTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NurseTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: NurseTest.PubSub},
      # Start the Endpoint (http/https)
      NurseTestWeb.Endpoint
      # Start a worker by calling: NurseTest.Worker.start_link(arg)
      # {NurseTest.Worker, arg}
    ]

    :ets.new(:resp_config, [:named_table, :set])
    :ets.insert(:resp_config,{"status_code", 200})
    :ets.insert(:resp_config,{"header", {"accept", "application/json"}})
    :ets.insert(:resp_config,{"body", "{}"})

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NurseTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NurseTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
