defmodule Aurorex.Protocol.Parser do
  import Aurorex.Protocol.BinaryHelpers

  @type encodable_term ::
          {:byte, byte}
          | {:boolean, boolean}
          | {:string, string}
          | {:short, integer}
          | {:int, integer}
          | {:long, integer}

  def parse(state, parse_function) do
    case Aurorex.Client.read_msg(state) do
      <<0>> <> data -> {:ok, parse_function.(data)}
      <<1>> <> error -> {:ko, Aurorex.Protocol.Exception.parse(error)}
    end
  end

  def encode({:byte, v}) do
    case v do
      1 -> <<1>>
      0 -> <<0>>
    end
  end

  def encode({:boolean, v}) do
    case v do
      true -> <<1>>
      false -> <<0>>
    end
  end

  def encode({:string, v}) when v == nil or byte_size(v) == 0 do
    encode({:int, -1})
  end

  def encode({:string, v}) do
    encode({:int, byte_size(v)}) <> v
  end

  def encode({:short, v}) do
    <<v::short>>
  end

  def encode({:int, v}) do
    <<v::int>>
  end

  def encode({:long, v}) do
    <<v::long>>
  end

  @spec encode_list([encodable_term]) :: {:ok}
  def encode_list(list) when is_list(list) do
    Enum.map(list, &encode/1)
  end

  def decode(<<data, rest::binary>>, :byte) do
    {data, rest}
  end

  def decode(<<data, rest::binary>>, :boolean) do
    case data do
      1 -> {true, rest}
      0 -> {false, rest}
    end
  end

  def decode(<<data::short, rest::binary>>, :short) do
    {data, rest}
  end

  def decode(<<data::int, rest::binary>>, :int) do
    {data, rest}
  end

  def decode(<<data::long, rest::binary>>, :long) do
    {data, rest}
  end

  def decode(<<0::int, rest::binary>>, :bytes) do
    {nil, rest}
  end

  def decode(<<length::int, data::binary>>, :bytes) do
    case data do
      <<parsed::bytes-size(length), rest::binary>> -> {parsed, rest}
      _ -> :incomplete
    end
  end

  def decode(data, :string) do
    case decode(data, :bytes) do
      {parsed, rest} ->
        if parsed == nil or String.valid?(parsed) do
          {parsed, rest}
        else
          :incomplete
        end

      :incomplete ->
        :incomplete
    end
  end
end
