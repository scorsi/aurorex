defmodule Aurorex do
  @moduledoc """
  """

  alias Aurorex.Connector.Client

  def main do
    {:ok, state} = Client.start_link()
    IO.inspect state
  end
end
