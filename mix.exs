defmodule Jeryldevcms.MixProject do
  use Mix.Project

  def project do
    [
      app: :jeryldevcms,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.cobertura": :test,
        "ghci.local": :test
      ],
      dialyzer: [
        ignore_warnings: "dialyzer.ignore-warnings",
        # Put the project-level PLT in the priv/ directory (instead of the default _build/ location)
        plt_file: {:no_warn, "priv/plts/project.plt"}

        # The above is equivalent to:
        # plt_local_path: "priv/plts/project.plt"

        # You could also put the core Erlang/Elixir PLT into the priv/ directory like so:
        # plt_core_path: "priv/plts/core.plt"
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Jeryldevcms.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # TODO bump on release to {:phoenix_live_view, "~> 1.0.0"},
      {:phoenix_live_view, "~> 1.0.0-rc.1", override: true},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:credo, "~> 1.7.7", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.3", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18.1", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.1.4", only: [:dev, :test], runtime: false},
      {:beacon, github: "BeaconCMS/beacon", override: true},
      {:beacon_live_admin, github: "BeaconCMS/beacon_live_admin"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind jeryldevcms", "esbuild jeryldevcms"],
      "assets.deploy": [
        "tailwind jeryldevcms --minify",
        "esbuild jeryldevcms --minify",
        "phx.digest"
      ],
      "ghci.local": [
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "sobelow -i Config.HTTPS",
        "dialyzer --format dialyzer",
        "coveralls"
      ]
    ]
  end
end
