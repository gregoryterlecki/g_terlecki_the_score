defmodule GTerleckiTheScore.RushingSearch do
    alias GTerleckiTheScore.{Repo, Rushing}
    import Ecto.Query

    def get_records(state, offset) do
        %{
            name: name, 
            data: %{
                page_size: page_size, 
                page_number: page_number
            }
        } = state.assigns
        Rushing
        |> where([r], ilike(r.player, ^"%#{name}%"))
        |> Repo.paginate(page: page_number + offset, page_size: page_size)
    end

    def get_records(name, page_number, page_size) do
        Rushing
        |> where([r], ilike(r.player, ^"%#{name}%"))
        |> Repo.paginate(page: page_number, page_size: page_size)
    end
end