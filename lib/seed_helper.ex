defmodule MovieScheduler.SeedHelper do
	def default_hour_fields() do
		Enum.reduce(1..48, %{}, fn 
			n, acc ->
				Map.merge(acc, %{:"#{n}" => %{length: 1, asset_id: nil}})
		end)
	end

	def default_hour_fields(i, attr) do
		%{:"#{i}" => attr}
	end

	def default_hour_fields(the_start, the_end, attr) do
		Enum.reduce(the_start..the_end, %{}, fn 
			n, acc ->
				Map.merge(acc, %{:"#{n}" => attr})
		end)
	end

	def movies() do
		%{status_code: 200, body: body} = 
			HTTPoison.get!("https://test-bumpers.s3.amazonaws.com/an/int/assets.json") 

		#File.read!("./priv/static/movies.json")
		body
		|> Poison.decode!
	end
end