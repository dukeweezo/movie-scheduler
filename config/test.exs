import Config

config :movie_scheduler, api_endpoint: "http://localhost:1988/api_v1"

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :movie_scheduler, MovieScheduler.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "movie_scheduler_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :movie_scheduler, MovieSchedulerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "b21vbofSPVkfHM51oSH32u+BVmkw5CBzXHXw3khAKGABiIdo0bwdDhBu94iTdplt",
  server: false

# In test we don't send emails.
config :movie_scheduler, MovieScheduler.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
