defmodule GTerleckiTheScore.Export do
    use GTerleckiTheScoreWeb, :controller
    alias GTerleckiTheScore.Repo

    def handle_export(conn, params) do
        conn =
            conn
            |> put_resp_header("content-disposition", "attachment; filename=rushing.csv")
            |> put_resp_content_type("text/csv")
            |> send_chunked(200)

        {:ok, conn} =
            Repo.transaction(fn ->
                build_query(params)
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

    defp build_query(%{"name" => name, "page" => page_number, "page_size" => page_size} = _params) do
        columns_csv = ~w(Player Team Pos Att/G Att Yds Avg Tds/G TD Lng 1st 1st% 20+ 40+ FUM)
        columns = ~w(player team position rushing_attempts_per_game_average rushing_attempts total_rushing_yards rushing_average_yards_per_attempt rushing_yards_per_game total_rushing_touchdowns longest_rush longest_rush_touchdown rushing_first_downs rushing_first_down_percentage rushing_20_yards_each rushing_40_yards_each rushing_fumbles)
        page_number = String.to_integer(page_number)
        page_size = String.to_integer(page_size)

        offset = (page_number - 1) * page_size |> Integer.to_string()
        limit = Integer.to_string(page_size)

        query = """
            COPY (
            SELECT #{Enum.join(columns, ",")}
            FROM rushing
            WHERE player ILIKE '%#{name}%'
            OFFSET #{offset}
            LIMIT #{limit}
            ) to STDOUT WITH CSV DELIMITER ',';
        """

        csv_header = [Enum.join(columns_csv, ","), "\n"]

        Ecto.Adapters.SQL.stream(Repo, query, [], max_rows: 500)
        |> Stream.map(&(&1.rows))
        |> (fn stream -> Stream.concat(csv_header, stream) end).()
    end

end