defmodule FreshaStyleGuide.MixProject do
  use Mix.Project

  @description "Official style guide for Elixir and Phoenix projects at Fresha"
  @github_url "https://github.com/surgeventures/elixir"

  def project do
    [
      app: :fresha_style_guide,
      version: "0.1.0",
      elixir: "~> 1.8",
      name: "Fresha Style Guide",
      description: @description,
      deps: deps(),
      docs: docs(),
      package: package()
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

  defp package do
    [
      maintainers: ["Karol Słuszniak"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github_url
      }
    ]
  end
end
