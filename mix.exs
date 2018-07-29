defmodule Aurorex.MixProject do
  use Mix.Project

  @client_name "Aurorex (Elixir client)"
  @binary_protocol_version 36
  @version "0.0.1"

  def project do
    [
      app: :aurorex,
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
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
      extra_applications: [:logger],
      env: [
        client_name: @client_name,
        binary_protocol_version: @binary_protocol_version,
        version: @version
      ]
    ]
  end

  defp description do
    """
    Elixir OrientDB Object Graph Mapping
    """
  end

  defp deps do
    [
      {:connection, "~> 1.0.0"},
      {:socket, "~> 0.3"}
    ]
  end
end
