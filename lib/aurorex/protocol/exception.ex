defmodule Aurorex.Protocol.Exception do
  alias Aurorex.Protocol.Parser

  @type t :: %{stack: [%{name: String.t(), message: String.t()}], serialized: any}

  @spec parse(binary) :: %{stack: [%{name: String.t(), message: String.t()}], serialized: any}
  def parse(data) do
    {_last_session_id, data} = Parser.decode(data, :int)
    parse(data, [])
  end

  defp parse(<<1, data::binary>>, exceptions) do
    {exception_name, data} = Parser.decode(data, :string)
    {exception_message, data} = Parser.decode(data, :string)
    parse(data, [exceptions ++ %{name: exception_name, message: exception_message}])
  end

  defp parse(<<0, data::binary>>, exceptions) do
    %{stack: exceptions, serialized: data}
  end
end
