defmodule Stripe.Mixfile do
  use Mix.Project

  def project do
    [ app: :stripity_stripe,
      version: "1.6.2",
      description: description(),
      package: package(),
      deps: deps(),
      elixir: "~> 1.1",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ]]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, ">= 0.0.0" },
      {:uri_query, "~> 0.1.2"},
      {:poison, ">= 0.0.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:exvcr, ">= 0.0.0", only: :test},
      {:mock, ">= 0.0.0", only: :test},
      {:inch_ex, ">= 0.0.0", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    A Stripe Library for Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Rob Conery","Nic Rioux", "Josh Smith", "Nikola Begedin", "Scott Newcomer"],
      licenses: ["New BSD"],
      links: %{
        "GitHub" => "https://github.com/code-corps/stripity-stripe",
        "Docs" => "https://hexdocs.pm/stripity_stripe"
      }
    ]
  end

end
