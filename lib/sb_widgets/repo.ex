defmodule SbWidgets.Repo do
  use Ecto.Repo,
    otp_app: :sb_widgets,
    adapter: Ecto.Adapters.Postgres
end
