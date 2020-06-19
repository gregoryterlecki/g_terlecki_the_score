defmodule GTerleckiTheScore.RushingSearch do
    alias GTerleckiTheScore.{Repo, Rushing}
    import Ecto.Query

    def get_records(state) do
        IO.puts "In rushing search 1"
        %{name: name, data: %{entries: entries, page_size: page_size, page_number: page_number}} = state.assigns
        Rushing
        |> where([r], ilike(r.player, ^"%#{name}%"))
        |> Repo.paginate(page: page_number, page_size: page_size)
    end

    def get_records(name, page_number, page_size) do
        IO.puts "In rushing search 2"
        Rushing
        |> where([r], ilike(r.player, ^"%#{name}%"))
        |> Repo.paginate(page: page_number, page_size: page_size)
    end
end