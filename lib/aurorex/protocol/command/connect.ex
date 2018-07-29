defmodule Aurorex.Protocol.Command.Connect do
  @moduledoc """
  The REQUEST_CONNECT operation.
  See: https://orientdb.com/docs/3.0.x/internals/Network-Binary-Protocol.html#requestconnect
  """

  alias Aurorex.Client
  alias Aurorex.Client.State
  alias Aurorex.Protocol.Codes
  alias Aurorex.Protocol.Parser

  @serialization_protocol "ORecordSerializerBinary"

  @spec execute(%State{}) :: {:ok}
  def execute(state) do
    IO.inspect([Codes.get_code(:connect), Parser.encode_list(get_opts(state))])
    IO.inspect(Client.send_msg(state, [Codes.get_code(:connect), Parser.encode_list(get_opts(state))]))
  end

  defp get_opts(%State{username: username, password: password}) do
    [
      # session id
      {:string, nil},
      # driver-name
      {:string, Application.get_env(:aurorex, :client_name)},
      # driver-version
      {:string, Application.get_env(:aurorex, :version)},
      # protocol-version
      {:short, Application.get_env(:aurorex, :binary_protocol_version)},
      # client-id
      {:string, nil},
      # serialization-impl
      {:string, @serialization_protocol},
      # token-session
      {:boolean, false},
      # support-push
      {:boolean, false},
      # collect-stats
      {:boolean, false},
      # user-name
      {:string, username},
      # user-password
      {:string, password}
    ]
  end
end
