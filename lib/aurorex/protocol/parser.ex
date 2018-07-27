defmodule Aurorex.Protocol.Parser do
  import Aurorex.Protocol.BinaryHelpers

  @ok        <<0>>
  @error     <<1>>
  @push_data <<3>>

  defp parse_header(@ok <> <<sid :: int, rest :: binary>>),
    do: {:ok, sid, rest}
  defp parse_header(@error <> <<sid :: int, rest :: binary>>),
    do: {:error, sid, rest}
  defp parse_header(_),
    do: :incomplete

  @doc """
  Parses the response to a given operation.

  `op_name` (the name of the operation as an atom, like `:record_load`) is used
  to determine the structure of the response. `schema` is passed down to the
  record deserialization (in case there are records) in order to decode possible
  property ids.

  The return value is a three-element tuple:

    * the first element is the session id of the response.
    * the second element is the actual response (which can be `{:ok, something}`
      or `{:error, reason}`.
    * the third element is what remains of `data` after parsing it according to
      `op_name`.

  """
  @spec parse_resp(atom, binary, Dict.t) ::
    :incomplete |
    {integer, {:ok, term} | {:error, term}, binary}
  def parse_resp(op_name, data, schema) do
    case parse_header(data) do
      :incomplete ->
        :incomplete
      {:ok, sid, rest} ->
        case parse_resp_contents(op_name, rest, schema) do
          :incomplete ->
            :incomplete
          {resp, rest} ->
            {sid, {:ok, resp}, rest}
        end
      {:error, sid, rest} ->
        case parse_errors(rest) do
          :incomplete ->
            :incomplete
          {error, rest} ->
            {sid, {:error, error}, rest}
        end
    end
  end

  @doc """
  Parses the response to a connection operation.

  Works very similarly to `parse_resp/3`.
  """
  @spec parse_connection_resp(binary, atom) ::
    :incomplete |
    {integer, {:ok, term} | {:error, term}, binary}
  def parse_connection_resp(data, connection_op) do
    parse_resp(connection_op, data, %{})
  end
end
