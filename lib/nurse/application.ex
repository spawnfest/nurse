defmodule Nurse.Application do
  @moduledoc false
  use Application

  alias Nurse.Dets
  alias Nurse.Healthcheck

  require Nurse

  def start(_type, _args) do
    base_children = [
      # Start the Ecto repository
      Nurse.Repo,
      # Start the Telemetry supervisor
      NurseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Nurse.PubSub},
      # Start the Endpoint (http/https)
      NurseWeb.Endpoint
    ]

    Nurse.table()
    |> Dets.open_or_create()

    healthchecks =
      Nurse.table()
      |> Dets.table_to_list()
      |> Enum.map(fn tuple ->
        tuple |> Healthcheck.from_tuple() |> Healthcheck.update({:health_status, :starting})
      end)

    workers =
      healthchecks
      |> Enum.map(fn healthcheck ->
        {Nurse.Worker, healthcheck}
      end)

    children = base_children ++ workers

    opts = [strategy: :one_for_one, name: Nurse.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NurseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
