defmodule Aurorex do
  @moduledoc """
  Documentation for Aurorex.
  """

  alias Aurorex.Connector.Client

  def main do
    {:ok, pid} = Client.start_link "localhost", 2424, {}
    Client.stop pid
  end
end

Aurorex.main()
