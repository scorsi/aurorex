defmodule Aurorex.Protocol.BinaryHelpers do
  @moduledoc false

  @moduledoc """
  This module provides some helpers to be used when pattern matching with the binary syntax. For example:

    <<record_version :: int, ...>> = data

  These helpers are tied to OrientDB's binary protocol.
  """

  @doc """
  2 bytes
  """
  defmacro short do
    quote do: 16-signed
  end

  @doc """
  4 bytes
  """
  defmacro int do
    quote do: 32-signed
  end

  @doc """
  8 bytes
  """
  defmacro long do
    quote do: 64-signed
  end
end
