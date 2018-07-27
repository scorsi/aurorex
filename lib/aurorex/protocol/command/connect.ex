defmodule Aurorex.Protocol.Command.Connect do
  import Aurorex.Protocol.BinaryHelpers
  alias Aurorex.Connector.Client

  @min_protocol 28

  @serialization_protocol "ORecordSerializerBinary"

  @typep state :: Map.t

  @spec connect(state) :: {:ok, state} | {:error, term, state} | {:tcp_error, term, state}
  def connect(s) do
    case negotiate_protocol(s) do
      {:ok, s} -> authenticate(s)
      {:tcp_error, reason} -> {:tcp_error, reason, s}
    end
  end

  @spec negotiate_protocol(state) :: {:ok, state} | {:tcp_error, term, state}
  defp negotiate_protocol(s) do
    case Client.read_msg(s) do
      {:ok, <<version :: short>>} ->
        check_protocol_version!(version)
        {:ok, %{s | protocol_version: version}}
      {:error, reason} ->
        {:tcp_error, reason}
    end
  end

  defp check_protocol_version!(protocol) when protocol < @min_protocol do
    raise Error, """
    the minimum supported protocol is #{@min_protocol}, the server is using #{protocol}
    """
  end

  defp check_protocol_version!(_) do
    :ok
  end

  defp authenticate(s) do
    {op, args} = op_and_connection_args(s)
    req = Protocol.encode_op(op, args)

    case Client.send_msg(s, req) do
      :ok ->
        wait_for_connection_response(s, op)
      {:error, reason} ->
        {:tcp_error, reason, s}
    end
  end

  defp op_and_connection_args(%{opts: opts}) do
    protocol = Application.get_env(:aurorex, :binary_protocol_version)
    {op, other_args} = op_and_args_from_connection_type(Keyword.fetch!(opts, :connection))

    static_args = [
      nil, # session id, nil (-1) for first-time connections
      Application.get_env(:aurorex, :client_name),
      Application.get_env(:aurorex, :version),
      {:short, protocol},
      "client id",
      @serialization_protocol,
      false, # token-based auth, not supported
    ]

    user = Keyword.fetch!(opts, :user)
    password = Keyword.fetch!(opts, :password)

    {op, static_args ++ other_args ++ [user, password]}
  end

  defp op_and_args_from_connection_type(:server),
    do: {:connect, []}
  defp op_and_args_from_connection_type({:db, name}),
    do: {:db_open, [name]}
  defp op_and_args_from_connection_type({:db, _name, _type}),
    do: raise(ArgumentError, "the database type is not supported (anymore) when connecting to a database, use {:db, db_name} instead")
  defp op_and_args_from_connection_type(_type),
    do: raise(ArgumentError, "invalid connection type, valid ones are :server or {:db, name}")

  defp wait_for_connection_response(s, connection_type) do
    case Client.read_msg(s, 0) do
      {:error, reason} ->
        {:tcp_error, reason, s}
      {:ok, new_data} ->
        data = s.tail <> new_data
        case Protocol.parse_connection_resp(data, connection_type) do
          :incomplete ->
            wait_for_connection_response(%{s | tail: data}, connection_type)
          {-1, {:error, err}, rest} ->
            {:error, err, %{s | tail: rest}}
          {-1, {:ok, [sid, _token]}, rest} ->
            {:ok, %{s | session_id: sid, tail: rest}}
        end
    end
  end
end
