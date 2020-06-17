defmodule GTerleckiTheScore.Repo do
  use Ecto.Repo,
    otp_app: :g_terlecki_the_score,
    adapter: Ecto.Adapters.Postgres
  
  use Scrivener, page_size: 10
end
