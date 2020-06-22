alias GTerleckiTheScore.{Repo, Rushing}

parse_total_rushing_yards = fn
    number when is_integer(number) -> number
    number -> number |> String.replace(",", "") |> Integer.parse() |> elem(0)
end

parse_longest_rush_touchdown = fn
    number when is_integer(number) -> false
    number -> number |> String.contains?("T")
end

parse_longest_rush = fn
    number when is_integer(number) -> number
    number -> number |> String.replace("T", "") |> Integer.parse() |> elem(0)
end

json_file = "priv/repo/rushing.json"

with {:ok, body} <- File.read(json_file),
     {:ok, json} <- Poison.decode(body) do

    json2 = Enum.map(json, & %{
        rushing_first_downs: &1["1st"],
        rushing_first_down_percentage: &1["1st%"],
        rushing_20_yards_each: &1["20+"],
        rushing_40_yards_each: &1["40+"],
        rushing_attempts: &1["Att"],
        rushing_attempts_per_game_average: &1["Att/G"],
        rushing_average_yards_per_attempt: &1["Avg"],
        rushing_fumbles: &1["FUM"],
        longest_rush: parse_longest_rush.(&1["Lng"]),
        longest_rush_touchdown: parse_longest_rush_touchdown.(&1["Lng"]),
        player: &1["Player"],   
        position: &1["Pos"],
        total_rushing_touchdowns: &1["TD"],
        team: &1["Team"],
        total_rushing_yards: parse_total_rushing_yards.(&1["Yds"]),
        rushing_yards_per_game: &1["Yds/G"]
    })

    Repo.insert_all(Rushing, json2)
    
else
  err ->
      IO.inspect(err)
end 