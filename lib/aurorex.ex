defmodule Aurorex do
  @moduledoc """
  """

  alias Aurorex.Connector.Client
  alias Aurorex.Connector.Client.State

  def main do
    {:ok, %State{} = state} = Client.start_link([host: "www.google.com", port: 80])
    IO.inspect state
    IO.inspect Client.read_msg(state)
  end
end


Aurorex.main()
