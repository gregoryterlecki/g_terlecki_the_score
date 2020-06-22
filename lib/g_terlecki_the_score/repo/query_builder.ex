defmodule GTerleckiTheScore.QueryBuilder do
    alias GTerleckiTheScore.{Repo, Rushing}
    import Ecto.Query

    def produce_query(params) do
        produce_query(params, 0)
    end

    def produce_query(%{
            name: name, 
            order_by: order_by,
            page_size: page_size,
            data: %{page_number: page_number}
        } = _params, incr) do

        total_records = Repo.aggregate(Rushing, :count)
        page_number = process_page_number(page_number, page_size, total_records, incr)
        offset = (page_number - 1) * page_size

        query = from r in Rushing,
            where: ilike(r.player, ^"%#{name}%"),
            order_by: ^order_by,
            offset: ^offset,
            limit: ^page_size
        
        %{
            query: query,
            total_records: total_records,
            page_number: page_number
        }
        
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