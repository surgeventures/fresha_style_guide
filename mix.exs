defmodule FreshaStyleGuide.MixProject do
  use Mix.Project

  def project do
    [
      app: :fresha_style_guide,
      version: "2.0.0",
      elixir: "~> 1.8",
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.20.2", only: [:dev], runtime: false}
    ]
  end

  defp docs do
    [
      main: "FreshaStyleGuide"
    ]
  end
end
