defmodule Aurorex.Protocol.CheckProtocolVersion do
  import Aurorex.Protocol.BinaryHelpers

  alias Aurorex.Client
  alias Aurorex.Client.State

  @minimal_protocol_version 32

  @spec execute(%State{}) :: {:ok} | {:ko}
  def execute(state) do
    case Client.read_msg(state) do
      <<version::short>> ->
        if version > @minimal_protocol_version do
          {:ok}
        else
          {:ko}
        end

      {:ok, _} ->
        {:ko}
    end
  end
end
