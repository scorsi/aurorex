defmodule Aurorex.Connector.Client do
  @moduledoc """

  """

  use Connection

  @initial_state %{

  }

  ## CLIENT

  @doc """
  Starts the current `Connection` to the OrientDB server
  """
  @spec start_link(String, Integer, Map, Integer) :: GenServer.on_start
  def start_link(host, port, opts, timeout \\ 5000) do
    case Connection.start_link(__MODULE__, {host, port, opts, timeout}) do
      {:ok, pid} = res ->
        IO.inspect pid
        res
      {:error, _} = err ->
        err
    end
  end

  @doc """
  Shuts down the connection (asynchronously since it's a cast).
  """
  @spec stop(pid) :: :ok
  def stop(pid) do
    Connection.cast(pid, :stop)
  end

  ## CALLBACKS

  @doc """
  Init method call automatically by the `start_link/4`
  """
  def init(state) do
    {:ok, state}
  end

  def handle_cast(:stop, s) do
    {:disconnect, :stop, s}
  end

  def disconnect(:stop, s) do
    {:stop, :normal, s}
  end
end
