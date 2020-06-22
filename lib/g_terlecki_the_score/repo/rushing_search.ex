defmodule GTerleckiTheScore.RushingSearch do
    alias GTerleckiTheScore.{Repo, Rushing}
    import Ecto.Query

    def get_records(name, page_number, page_size) do
        Rushing
        |> where([r], ilike(r.player, ^"%#{name}%"))
        |> Repo.paginate(page: page_number, page_size: page_size)
    end


    def get_records(state, incr) do
        %{
            name: name, 
            order_by: order_by,
            data: %{
                page_size: page_size, 
                page_number: page_number
            }
        } = state.assigns
        total_records = Repo.aggregate(Rushing, :count)
        offset = (page_number - 1) * page_size
        page_number = process_page_number(page_number, page_size, total_records, incr)
        query = from r in Rushing,
            where: ilike(r.player, ^"%#{name}%"),
            order_by: ^order_by,
            offset: ^offset,
            limit: ^page_size
        
        val = Ecto.Adapters.SQL.to_sql(:all, Repo, query)
        
        # {query, params} = Ecto.Adapters.SQL.to_sql(:all, Repo, query)
        # IO.puts('#{query}, #{params}')
        IO.inspect('#{elem(val, 0)}')
        %{
            entries: Repo.all(query), 
            page_number: page_number, 
            page_size: page_size
        }
    end

    defp produce_query_string(query, params) do
        Enum.reduce(params, query, fn param, query_string -> 
            Regex.replace(~r/\$\d+/, query_string, param, global: false)
        end)
    end

    def process_page_number(page_number, page_size, total_records, incr) do
        if is_page_valid?(page_number + incr, page_size, total_records) do
            page_number + incr
        else 
            page_number
        end
    end

    defp is_page_valid?(page_number, _page_size, _total_records) when page_number < 1 do 
        false 
    end

    defp is_page_valid?(page_number, page_size, total_records) do
        max_pages = 
            total_records / page_size
            |> Float.ceil()
            |> trunc()

        range = Range.new(1, max_pages)
        Enum.member?(range, page_number)
    end

end