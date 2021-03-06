defmodule Aurorex.Protocol.Command.Connect do
  @moduledoc """
  The REQUEST_CONNECT operation.
  See: https://orientdb.com/docs/3.0.x/internals/Network-Binary-Protocol.html#requestconnect.
  """

  import Aurorex.Protocol.BinaryHelpers

  alias Aurorex.Client
  alias Aurorex.Client.State
  alias Aurorex.Protocol.Codes
  alias Aurorex.Protocol.Exception
  alias Aurorex.Protocol.Parser

  @serialization_protocol "ORecordSerializerBinary"

  @spec execute(%State{}) ::
          {:ok, %{session_id: String.t(), token_id: String.t()}}
          | {:ko, Exception.t()}
  def execute(state) do
    opts = Parser.encode_list(get_opts(state))
    :ok = Client.send_msg(state, [Codes.get_code(:connect), opts])

    Parser.parse(state, &parse/1)
  end

  def parse(data) do
    {_last_session_id, data} = Parser.decode(data, :int)
    {new_session_id, data} = Parser.decode(data, :int)
    {token_id, ""} = Parser.decode(data, :bytes)
    %{session_id: new_session_id, token_id: token_id}
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
