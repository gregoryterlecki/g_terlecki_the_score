defmodule GTerleckiTheScore.Repo.Migrations.CreateRushingTable do
  use Ecto.Migration

  def change do
    create table("rushing") do
      add :player, :string, size: 64
      add :team, :string, size: 16
      add :position, :string, size: 16
      add :rushing_attempts_per_game_average, :decimal
      add :rushing_attempts, :integer
      add :total_rushing_yards, :integer # on record creation, might be string. Has to be casted
      add :rushing_average_yards_per_attempt, :decimal
      add :rushing_yards_per_game, :decimal
      add :total_rushing_touchdowns, :integer
      add :longest_rush, :integer #type casting to string will also be needed here
      add :longest_rush_touchdown, :boolean
      add :rushing_first_downs, :integer
      add :rushing_first_down_percentage, :decimal
      add :rushing_20_yards_each, :integer
      add :rushing_40_yards_each, :integer
      add :rushing_fumbles, :integer
    end
  end
end
