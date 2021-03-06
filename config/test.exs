use Mix.Config

# Configure your database
config :rumbl, Rumbl.Repo,
  username: "dev",
  password: "marchewka",
  database: "rumbl_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rumbl, RumblWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# minimum hashing of password for faster tests
config :pbkdf2_elixir, :rounds, 1
