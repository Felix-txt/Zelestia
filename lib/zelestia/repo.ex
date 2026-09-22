defmodule Zelestia.Repo do
  use Ecto.Repo,
    otp_app: :zelestia,
    adapter: Ecto.Adapters.Postgres
end
