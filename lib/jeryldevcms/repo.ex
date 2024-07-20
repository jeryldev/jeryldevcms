defmodule Jeryldevcms.Repo do
  use Ecto.Repo,
    otp_app: :jeryldevcms,
    adapter: Ecto.Adapters.Postgres
end
