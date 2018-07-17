defmodule Aurorex.MixProject do
  use Mix.Project

  @binary_protocol_version 33
  @version "0.0.1"

  def project do
    [
      app: :aurorex,
      version: "0.0.1",
      elixir: "~> 1.6",

      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,

      package: package(),
      description: description(),

      deps: deps()
    ]
  end

  defp package do
    [
      maintainers: ["Sylvain CORSINI"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/scorsi/aurorex"}
    ]
   end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Elixir OrientDB Object Graph Mapping
    """
  end

  defp deps do
    [
      {:connection, "~> 1.0.0"}
    ]
  end
end
