defmodule IntercomX.MixProject do
  use Mix.Project

  def project do
    [
      app: :intercomx,
      version: "0.0.1",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],

      # Docs
      name: "IntercomX",
      description: "Unofficial Intercom API client written in Elixir",
      source_url: "https://github.com/Codaisseur/intercomx",
      homepage_url: "https://github.com/Codaisseur/intercomx",
      docs: docs(),
      package: package()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {IntercomX.Application, [env: Mix.env]},
      applications: applications(Mix.env)
    ]
  end

  defp applications(:test), do: applications(:default) ++ [:cowboy, :plug]
  defp applications(_),     do: [:httpoison]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.11.2", only: :test},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:httpoison, "~> 1.6"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Codaisseur/intercomx"}
    ]
  end

  defp docs do
    [
      main: "IntercomX",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE.md"
      ]
    ]
  end
end
