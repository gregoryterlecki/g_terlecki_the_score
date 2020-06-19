defmodule GTerleckiTheScoreWeb.PageLive do
  use GTerleckiTheScoreWeb, :live_view
  alias GTerleckiTheScore.{Repo, Rushing, RushingSearch}
  import Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(:name, "")
      |> assign(page_size: 10)
      |> assign(:data, RushingSearch.get_records("", 1, 10))
    }
  end

  @impl true
  def handle_event("search", %{"search_form" => %{"name" => name}}, socket) do
    # find a way to preserve the name input after clicking refresh
    socket = assign(socket, name: name)
    {:noreply, 
      socket
      |> assign(data: RushingSearch.get_records(socket, 0))
    }
  end

  def handle_event("dec", _event, socket) do
    {:noreply,
      assign(socket, data: RushingSearch.get_records(socket, -1))
    }
  end

  def handle_event("inc", _event, socket) do
    {:noreply, 
      assign(socket, data: RushingSearch.get_records(socket, 1))
    }
  end

  # pattern match on the socket to pull out the existing sort direction
  # {:yds, :desc}
  def handle_event("order_by_yds", event, socket) do
    {:noreply, 
      assign(socket, data: RushingSearch.get_records(socket, 0))
    }
  end

  def handle_event("page_size", event, socket) do
    {:noreply, 
      assign(socket, data: RushingSearch.get_records(socket, 0))
    }
  end

  def handle_event("export", event, socket) do
    # get params, arrange them into a query string
    # use httpoison to send a request to a route
    # define this route, make controller to handle the request
    # in this controller, use your RushingSearch module to handle the export
    %{name: name, data: %{page_number: page_number}} = socket.assigns
    url = "http://localhost:4000/api/export?name="<>name<>"&page_number="<>Integer.to_string(page_number)
    HTTPoison.get(url)
    {:noreply, socket}
  end

  # move this out to a separate module accessible by this one and the controller (for csv export)
  def get_records(name, page_number, page_size) do
    # have this funciton take the socket itself
    Rushing
    |> where([r], ilike(r.player, ^"%#{name}%"))
    |> Repo.paginate(page: page_number, page_size: page_size)
  end

  defp get_state(socket) do
    %{name: name, data: data} = socket.assigns
  end

end


