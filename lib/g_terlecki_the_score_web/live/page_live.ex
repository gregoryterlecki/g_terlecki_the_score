defmodule GTerleckiTheScoreWeb.PageLive do
  use GTerleckiTheScoreWeb, :live_view
  alias GTerleckiTheScore.RushingRepo

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
      |> assign(:order_by, {:desc, :total_rushing_yards})
      |> assign(:name, "")
      |> assign(:page_size, 10)
      |> assign(:data, %{page_number: 1})
    {:ok, 
      assign(socket, :data, RushingRepo.get_records(socket))
    }
  end

  @impl true
  def handle_event("search", %{"search_form" => %{"name" => name}}, socket) do
    socket = assign(socket, name: name)
    {:noreply, 
      socket
      |> assign(data: RushingRepo.get_records(socket))
    }
  end

  def handle_event("dec", _event, socket) do
    {:noreply,
      assign(socket, data: RushingRepo.get_records(socket, -1))
    }
  end

  def handle_event("inc", _event, socket) do
    {:noreply, 
      assign(socket, data: RushingRepo.get_records(socket, 1))
    }
  end

  def handle_event("order_by", %{"id" => col}, socket) do
    col_atom = String.to_atom(col)
    order_by = case socket.assigns.order_by do
      {:desc, _} -> {:asc, col_atom}
      {:asc, _} -> {:desc, col_atom}
      {nil, nil} -> {:desc, col_atom}
    end
    {:noreply, 
      assign(socket, order_by: order_by, data: RushingRepo.get_records(socket))
    }
  end

  def handle_event("export", _event, socket) do
    %{name: name, data: %{page_number: page_number}} = socket.assigns
    url = "http://localhost:4000/api/export?name="<>name<>"&page_number="<>Integer.to_string(page_number)
    HTTPoison.get(url)
    {:noreply, socket}
  end

end
