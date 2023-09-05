alias MovieScheduler.Repo
alias MovieScheduler.Assets.Movie
import MovieScheduler.SeedHelper

# For use in dev.

Repo.delete_all Movie

for movie <- movies() do
	%{
		"title" => title, 
	  "description" => description, 
	  "duration" => duration, 
	  "image" => image
	} = movie
	
	Repo.insert! struct(Movie, %{
		title: title, 
	  description: description, 
	  duration: duration, 
	  image: image
	})
end
