defmodule MovieScheduler.Repo do
  use Ecto.Repo,
    otp_app: :movie_scheduler,
    adapter: Ecto.Adapters.Postgres
end
