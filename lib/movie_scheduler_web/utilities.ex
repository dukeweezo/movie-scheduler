defmodule MovieSchedulerWeb.Utilities do
  @moduledoc """
  Miscellaneous functions to generate time, dates, as well as functions (sort_grids/1,
  create_intermediary_grids/1, combine_grids/2 and combine_with_asset/2) to turn the
  database grid structure into a structure useful to LiveView and HTML grids. 

  More concretely, turning the structure from

  Database form (unsorted, each map in list corresponds to one day):
  [
    %{
      "47" => %{"asset_id" => nil, "length" => 1}, # "\#{number}" fields correspond to 30 min increments
      "id" => 4,                                   # id corresponds to date (less an earlier date)
      ...
    }
  ]
  sorted_grids/1 ->
  
  Database form (sorted by date):
  [
    %{
      "20" => %{"asset_id" => nil, "length" => 1},
      "id" => 1,
      ...
    }
  ]
  create_intermediary_grids/1 ->

  Intermediary structure:
  [
    {1, %{"asset_id" => "1", "length" => 3}, {1, 1}}, # {grid_id, values, {x, y}}
    {1, %{}, {1, 2}},
    {1, %{}, {1, 3}},
    ...
  ]
  combine_grids/2 ->

  Final structure (with Grid struct, without asset data):
  [
    %MovieScheduler.Grid{
      grid_id: 1,
      x: 1, 
      y: 1,
      length: 3,
      schedule_id: 1,     # corresponds to day / date 
      asset_id: "1",
      relative_row_id: 1, # relative row within day / date
      asset: nil
    }, 
    {}, 
    {},
    ...
  ]
  combine_with_asset/2 ->

  Final structure (with Grid struct, with asset data):
  [
    %MovieScheduler.Grid{
      grid_id: 1,
      x: 1,
      y: 1,
      length: 3,
      schedule_id: 1,     
      asset_id: "1",
      relative_row_id: 1, 
      asset: %{
        "description" => "Brennan Huff, a sporadically employed thirty-nine-year-old who lives with his mother, Nancy..."
        "duration" => 3,
        "formatted_length" => "1.46",
        "id" => 1,
        "image" => "https://image.xumo.com/v1/assets/asset/XM0RM6YREXZQ4B/600x337.webp",
        "title" => "Step Brothers"
      }
    },
    {},
    {},
    ...
  ]

  Note this flows from decisions regarding structure in database and view layer decisions
  (using HTML grids); pros and cons can be argued for these choices. Optimizations also can be made.

  """
  @moduledoc since: "1.0.0"

  alias MovieScheduler.Grid

  # Generate empty grids, to be combined with intermediary grid form, to create finished form.
  def generate_empty_grids() do
    {result, _} = 
      for x <- 1..5, y <- 1..48 do
        {x, y, 1}
      end
      |> Enum.map_reduce(1, fn 
        {x, y, length}, acc ->
          {%Grid{grid_id: acc, x: x, y: y, length: length, asset_id: nil}, acc + 1}
      end)

    result
  end

  # Convert current duration values (unsure what they represent) to a formatted value.
  # For single movie.
  def convert_movie_time_to_hours(movie = %{"duration" => duration}) do
		formatted_length = 
			Float.to_string(duration / 4000)
			|> String.slice(0..3)

		%{movie | "duration" => round(duration / 2000)} 
		|> Map.put("formatted_length", formatted_length)
  end

  # Convert current duration values (unsure what they represent) to a formatted value.
  # For multiple movies.
  def convert_movies_time_to_hours(movies) do
  	Enum.map(movies, fn 
  		movie = %{"duration" => duration} ->
  			formatted_length = 
	  			Float.to_string(duration / 4000)
	  			|> String.slice(0..3)

  			%{movie | "duration" => round(duration / 2000)} 
  			|> Map.put("formatted_length", formatted_length)
  	end)
  end

  # Generate dates for UI.
  # TODO: parameters to allow on-the-fly 1. starting date 2. number of days.
  def generate_dates(start_date \\ Timex.today() |> Timex.day()) when 1 < start_date and start_date < 365 do
    {dates, _} =
      Enum.map_reduce(1..5, start_date, fn 
        n, acc ->
          date = Timex.from_iso_day(acc)
          
          shorthand_name =
            date
            |> Timex.weekday
            |> Timex.day_shortname

          formatted_date =
            Timex.format!(date, "{M}/{D}")

          {{shorthand_name, formatted_date}, acc + 1}
      end)

    dates
  end

  # Generate 24 hr clock time in 30-min increments for UI.
  # TODO: parameters to allow on-the-fly 1. increments 2. format (24 hr clock vs 12 hr clock)
  def generate_24_hr_clock_time() do
    for n <- 1..48 do 
      is_even? = rem(n, 2) == 0
      is_odd? = rem(n, 2) != 0

      cond do
        n < 20 and is_even? ->
          "0#{round(n/2)}"
        is_even? ->
          "#{round(n/2)}"
        n < 20 and is_odd? ->
          "0#{trunc(n/2)}"
        is_odd? ->
           "#{trunc(n/2)}"
        true -> ""
      end
      <>
      if is_even? do
        ":00"
      else
        ":30"
      end
    end
  end

  # See module docs.
  def sort_grids(db_grids) do
    sorted_grids = 
      Enum.sort_by(db_grids, fn 
        %{"id" => id} ->
          id
      end,
      fn 
        id1, id2 ->
          if id1 < id2, do: true, else: false
      end)
  end

  # See module docs.
  def create_intermediary_grids(sorted_grids) do
    {intermediary_grids, _} =
      Enum.flat_map_reduce(sorted_grids, 0, fn 
        schedule, acc ->
          new_grids =
            for n <- 1..48 do
              case Map.fetch(schedule, "#{n}") do 
                {:ok, value} ->
                  {(acc * 48) + 1, value, {schedule["id"], n}}
                _ ->
                  {nil, acc}
              end
            end

          {new_grids, acc + 1}
      end)

    intermediary_grids
  end

  # See module docs.
  # TODO: clean up / refactor.
  def combine_grids(sorted_intermediary_grids, empty_grids) do
    {combined_grids, _} =
      Enum.map_reduce(empty_grids, 0, fn 
        empty = %{grid_id: grid_id, x: x, y: y, length: length}, acc ->
          fetched_grid = Enum.fetch!(sorted_intermediary_grids, acc)
          
          if fetched_grid !== nil do
            {_, values, {new_schedule_id, relative_row_id}} = fetched_grid

            case values do
              %{"empty" => true} ->
                {%Grid{grid_id: grid_id, x: x, y: y,
                       length: length, schedule_id: nil, 
                       asset_id: nil, relative_row_id: relative_row_id}, acc + 1}

              values when map_size(values) == 0 ->
                {{}, acc + 1}

              _ ->
                {%Grid{grid_id: grid_id, x: x, y: y,
                       length: values["length"], schedule_id: new_schedule_id, 
                       asset_id: values["asset_id"], relative_row_id: relative_row_id}, acc + 1}
            end
            
          else
            {%Grid{grid_id: grid_id, x: x, y: y,
                   length: length, schedule_id: nil, 
                   asset_id: nil, relative_row_id: nil}, acc + 1}
          end
        {}, acc ->
          {%Grid{}, acc + 1}
      end)

    combined_grids
  end

  # See module docs.
  def combine_with_asset(grids, fetch_fn) do
  	Enum.map(grids, fn 
  		grid = %{asset_id: nil} ->
  			grid
  		grid = %{asset_id: asset_id} ->
  			Map.put(grid, :asset, fetch_fn.(asset_id))
  		grid ->
  			grid
  	end)
  end
end