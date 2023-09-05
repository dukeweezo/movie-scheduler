defmodule MovieSchedulerWeb.APICalls do
	import MovieSchedulerWeb.Utilities
	@moduledoc """
  Interface with HTTPoison API adapter; also combination functions get_grids/1, get_movies/1, get_movie/1.
  """

	def create_schedule(values) do
	  payload = Poison.encode!(values)

	  case MovieSchedulerWeb.API.post("/schedules/", payload, [{"Accept", "application/json"}]) do
	    {:ok, %{status_code: 200, body: body}} ->
	      body
	    _ ->
	      []
	  end
	end

	def update_schedule(id, values) do
	  payload = Poison.encode!(values)

	  case MovieSchedulerWeb.API.put("/schedules/#{id}", payload, [{"Accept", "application/json"}]) do
	    {:ok, %{status_code: 200, body: body}} ->
	      body
	    _ ->
	      []
	  end
	end

	# For example, Mon - Fri.
	def get_schedules_x_days_out(x \\ 4) do
	  case MovieSchedulerWeb.API.get("/schedules/?action=list_schedules_x_days_out&value=#{x}") do
	    {:ok, %{status_code: 200, body: body}} ->
	      body
	    error ->
	      [] 
	  end
	end

	def get_schedules() do
	  case MovieSchedulerWeb.API.get("/schedules/") do
	    {:ok, %{status_code: 200, body: body}} ->
	      body
	    _ ->
	      []
	  end
	end

	defp get_asset(type, id) do
		case MovieSchedulerWeb.API.get("/#{type}/#{id}") do
	    {:ok, %{status_code: 200, body: body}} ->
	      body
	    _ ->
	      []
	  end
	end

	defp get_assets(type) do
		case MovieSchedulerWeb.API.get("/#{type}/") do
	    {:ok, %{status_code: 200, body: body}} ->
	      body
	    _ ->
	      []
	  end
	end

	# See MovieSchedulerWeb.Utilities for more information.
	def get_grids() do
	  empty_grids = generate_empty_grids()

	  get_schedules_x_days_out(4)
	  |> sort_grids()
	  |> create_intermediary_grids()
	  |> combine_grids(empty_grids)
	  |> combine_with_asset(&get_movie/1)
	end

	# TODO: one get_movies, etc. functions (less error-prone / confusing).
	def get_movies() do
	  get_assets("movies")
	  |> convert_movies_time_to_hours
	end

	# TODO: one get_movies, etc. function (less error-prone / confusing).
	def get_movie(id) do
	  get_asset("movies", id)
	  |> convert_movie_time_to_hours
	end
end