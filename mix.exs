defmodule Indulgences.MixProject do
  use Mix.Project

  def project do
    [
      app: :indulgences,
      version: "0.1.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "Indulgences",
      source_url: "https://github.com/TrsNium/Indulgences"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Indulgences.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.5"},
      {:memento, "~> 0.3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Distributed load test framework"
  end

  defp package() do
    [
      name: "indulgences",
      files: ~w(lib mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/TrsNium/Indulgences"}
    ]
  end
end
