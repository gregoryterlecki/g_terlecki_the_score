defmodule GTerleckiTheScore.Export do
    use GTerleckiTheScoreWeb, :controller
    alias GTerleckiTheScore.{Repo, QueryBuilder}

    def handle_export(conn, params) do
        conn =
            conn
            |> put_resp_header("content-disposition", "attachment; filename=rushing.csv")
            |> put_resp_content_type("text/csv")
            |> send_chunked(200)

        {:ok, conn} =
            Repo.transaction(fn ->
                get_query(params)
                |> Enum.reduce_while(conn, fn (data, conn) ->
                    case chunk(conn, data) do
                        {:ok, conn} ->
                        {:cont, conn}
                        {:error, :closed} ->
                        {:halt, conn}
                    end
                end)
            end)
        conn
    end

    defp get_query(params) do
        params = map_params(params)
        columns_csv = ~w(Player Team Pos Att/G Att Yds Avg Tds/G TD Lng 1st 1st% 20+ 40+ FUM)

        %{query: query} = QueryBuilder.produce_query(params)
        {query, params} = Ecto.Adapters.SQL.to_sql(:all, Repo, query)
        params = Enum.map(params, fn param -> if is_integer(param), do: Integer.to_string(param), else: "'#{param}'" end)
        query_string = produce_query_string(query, params)
        full_query_string = "COPY (#{query_string}) to STDOUT WITH CSV DELIMITER ',';"

        csv_header = [Enum.join(columns_csv, ","), "\n"]

        Ecto.Adapters.SQL.stream(Repo, full_query_string, [], max_rows: 500)
        |> Stream.map(&(&1.rows))
        |> (fn stream -> Stream.concat(csv_header, stream) end).()
    end

    defp produce_query_string(query, params) do
        Enum.reduce(params, query, fn param, query_string -> 
            Regex.replace(~r/\$\d+/, query_string, param, global: false)
        end)
    end

    defp map_params(%{
        "name" => name, 
        "page" => page_number, 
        "page_size" => page_size,
        "dir" => dir,
        "col" => col
    } = _params) do 
        %{
            name: name,
            order_by: {String.to_atom(dir), String.to_atom(col)},
            page_size: String.to_integer(page_size),
            data: %{page_number: String.to_integer(page_number)}
        }
    end

end