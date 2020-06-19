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
      |> assign(:data, get_records("", 1, 10))
    }
  end

  @impl true
  def handle_event("search", %{"search_form" => %{"name" => name}}, socket) do
    # find a way to preserve the name input after clicking refresh
    IO.inspect(name, label: "name")
    {:noreply, 
      socket
      |> assign(name: name)
      |> assign(data: get_records(get_name(socket), get_page_number(socket), get_page_size(socket)))
    }
  end

  def handle_event("dec", _event, socket) do
    {:noreply,
      assign(socket, data: get_records(get_name(socket), get_page_number(socket)-1, get_page_size(socket)))
    }
  end

  def handle_event("inc", _event, socket) do
    {:noreply, 
      assign(socket, data: get_records(get_name(socket), get_page_number(socket)+1, get_page_size(socket)))
    }
  end

  # pattern match on the socket to pull out the existing sort direction
  # {:yds, :desc}
  def handle_event("order_by_yds", event, socket) do
    {:noreply, 
      assign(socket, data: get_records(get_name(socket), get_page_number(socket)+1, get_page_size(socket)))
    }
  end

  @impl true
  def handle_event("page_size", event, socket) do
    {:noreply, 
      assign(socket, data: get_records(get_name(socket), get_page_number(socket), get_page_size(socket)))
    }
  end

  @impl true
  def handle_event("ob_yds", event, socket) do 
    
    {:noreply, socket}
  end

  @impl true
  def handle_event("export", event, socket) do
    %{name: name, data: %{entries: entries, page_size: page_size}} = get_state(socket)
    # IO.inspect(name, label: "name")
    # IO.inspect(entries, label: "entries")
    # IO.inspect(page_size, label: "page_size")
    {:noreply, socket}
  end

  # move this out to a separate module accessible by this one and the controller (for csv export)
  def get_records(name, page_number, page_size) do
    # have this funciton take the socket itself
    Rushing
    |> where([r], ilike(r.player, ^"%#{name}%"))
    |> Repo.paginate(page: page_number, page_size: page_size)
  end

  # refactor to use pattern matching on these field
  defp get_name(socket) do
    socket.assigns.name
  end

  defp get_page_number(socket) do
    socket.assigns.data.page_number
  end

  defp get_page_size(socket) do
    socket.assigns.data.page_size
  end

  defp get_state(socket) do
    %{name: name, data: data} = socket.assigns
  end

end


