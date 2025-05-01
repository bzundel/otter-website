defmodule OtterWebsite.Repo do
  use Ecto.Repo,
    otp_app: :otter_website,
    adapter: Ecto.Adapters.Postgres
end
