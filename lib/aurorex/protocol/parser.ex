defmodule Aurorex.Protocol.Parser do
  import Aurorex.Protocol.BinaryHelpers

  @type encodable_term ::
    {:byte, byte}
    | {:boolean, boolean}
    | {:string, string}
    | {:short, integer}
    | {:int, integer}
    | {:long, integer}

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

  def encode_op(op, opts) do

  end
end
