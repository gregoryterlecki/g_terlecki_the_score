defmodule GTerleckiTheScore.Rushing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushing" do
    field :player, :string, size: 64
    field :team, :string, size: 16
    field :position, :string, size: 16
    field :rushing_attempts_per_game_average, :decimal
    field :rushing_attempts, :integer
    field :total_rushing_yards, :integer # on record creation, might be string. Has to be casted
    field :rushing_average_yards_per_attempt, :decimal
    field :rushing_yards_per_game, :decimal
    field :total_rushing_touchdowns, :integer
    field :longest_rush, :integer #type casting to string will also be needed here
    field :longest_rush_touchdown, :boolean
    field :rushing_first_downs, :integer
    field :rushing_first_down_percentage, :decimal
    field :rushing_20_yards_each, :integer
    field :rushing_40_yards_each, :integer
    field :rushing_fumbles, :integer
  end

  @all_params ~w(player team position rushing_attempts_per_game_average rushing_attempts 
    total_rushing_yards rushing_average_yards_per_attempt rushing_yards_per_game total_rushing_touchdowns
    longest_rush rushing_first_downs rushing_first_down_percentage rushing_20_yards_each rushing_40_yards_each 
    rushing_fumbles)

  @required_params ~w(player team position rushing_attempts_per_game_average rushing_attempts 
    total_rushing_yards rushing_average_yards_per_attempt rushing_yards_per_game total_rushing_touchdowns
    longest_rush rushing_first_downs rushing_first_down_percentage rushing_20_yards_each rushing_40_yards_each 
    rushing_fumbles)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_params)
    |> validate_required(@required_params)
  end
end