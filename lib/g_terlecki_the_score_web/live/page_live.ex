defmodule GTerleckiTheScoreWeb.PageLive do
  use GTerleckiTheScoreWeb, :live_view
  alias GTerleckiTheScore.RushingSearch
  # import Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(:order_by, [nil, nil])
      |> assign(:name, "")
      |> assign(page_size: 10)
      |> assign(:data, RushingSearch.get_records("", 1, 10))
    }
  end

  @impl true
  def handle_event("search", %{"search_form" => %{"name" => name}}, socket) do
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

  def handle_event("ob_yards", _event, socket) do
    order_by = case socket.assigns.order_by do
      [dir, :total_rushing_yards] -> 
        [
          case dir do
            :desc -> :asc
            _ -> :desc
          end,
          :total_rushing_yards
        ]

      [_dir, _column] -> [:desc, :total_rushing_yards]
    end
    socket = assign(socket, :order_by, order_by)
    {:noreply, 
      assign(socket, data: RushingSearch.get_records(socket, 0))
    }
  end

  def handle_event("ob_longest_rush", _event, socket) do
    order_by = case socket.assigns.order_by do
      [dir, :longest_rush] -> 
        [ 
          case dir do
            :desc -> :asc
            _ -> :desc
          end,
          :longest_rush
        ]
      [_dir, _column] -> [:desc, :longest_rush]
    end
    socket = assign(socket, :order_by, order_by)
    {:noreply, 
      assign(socket, data: RushingSearch.get_records(socket, 0))
    }
  end

  def handle_event("export", _event, socket) do
    %{name: name, data: %{page_number: page_number}} = socket.assigns
    url = "http://localhost:4000/api/export?name="<>name<>"&page_number="<>Integer.to_string(page_number)
    HTTPoison.get(url)
    {:noreply, socket}
  end

end


