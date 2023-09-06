# MovieScheduler

![alt text](https://github.com/dukeweezo/movie-scheduler/blob/master/github-assets/1.png?raw=true)

  * LiveView, LiveComponents, and internal API for adding assets (movies) to single day.
  * Features 'grabbing', 'placing', 'removing' and 'get' (paginate through) asset actions.
  * API endpoints at `/api_v1/schedules` and `/api_v1/movies`.
  * Additional movie details at `/movies/[asset_id]`.
  * Includes migratons, seeds, etc.
  * Currently deployed to [https://movie-scheduler.fly.dev/](https://movie-scheduler.fly.dev/).
  * Tested on latest Chrome and Safari.

Have a go!

![alt text](https://github.com/dukeweezo/movie-scheduler/blob/master/github-assets/step_bros.gif?raw=true))

Example AWS architecture for frontend
![alt text](https://github.com/dukeweezo/movie-scheduler/blob/master/github-assets/architecture-1-whitebg.png))

Example AWS architecture for backend
![alt text](https://github.com/dukeweezo/movie-scheduler/blob/master/github-assets/architecture-2-whitebg.png))

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:1988`](http://localhost:1988) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
