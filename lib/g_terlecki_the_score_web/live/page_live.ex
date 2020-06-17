defmodule GTerleckiTheScoreWeb.PageLive do
  use GTerleckiTheScoreWeb, :live_view
  alias GTerleckiTheScore.{Repo, Rushing}
  import Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: "", data: get_records(""))}
  end

  @impl true
  def handle_event("search", %{"search_form" => %{"name" => name}}, socket) do
    {:noreply, assign(socket, data: get_records(name))}
  end

  def get_records(name) do
    Rushing
    |> where([r], ilike(r.player, ^"%#{name}%"))
    |> Repo.paginate()
  end
end


