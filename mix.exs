defmodule UAParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :uaparser,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.26.0"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:benchee, "~> 1.1.0"},
      {:ua_inspector, "~> 3.0"},
      {:ua_parser, "~> 1.8"},
      {:nimble_csv, "~>1.2.0"}
    ]
  end
end
