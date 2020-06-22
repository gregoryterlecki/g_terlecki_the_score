defmodule GTerleckiTheScore.RushingRepo do
    alias GTerleckiTheScore.{Repo, QueryBuilder}

    def get_records(state) do
        get_records(state, 0)
    end

    def get_records(state, incr) do
        %{
            query: query,
            page_number: page_number
        } = QueryBuilder.produce_query(state.assigns, incr)

        entries = Repo.all(query) # consider putting this, and the total entries thing into a Multi
        %{
            entries: entries,
            page_number: page_number
        }
    end

end