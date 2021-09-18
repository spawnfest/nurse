defmodule Nurse.Repo do
  use Ecto.Repo,
    otp_app: :nurse,
    adapter: Ecto.Adapters.Postgres
end
