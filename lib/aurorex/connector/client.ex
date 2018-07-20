defmodule Aurorex.Connector.Client do
  use Connection

  require Logger

  defmodule State do
    defstruct socket: nil, pid: nil, from: nil, address: nil
  end

  ## Client

  def start_link(state) do
    {:ok, pid} = Connection.start_link(__MODULE__, state)
    {:ok, %State{Connection.call(pid, {:get_state}) | pid: pid}}
  end

  def send_msg(%State{pid: pid}, msg) do
    Connection.call(pid, {:send_msg, msg})
  end

  def read_msg(%State{pid: pid}) do
    Connection.call(pid, {:read_msg})
  end

  ## Callbacks

  def init([host: host, port: port] = address) do
    socket = Socket.TCP.connect!(host, port)
    {:ok, %State{socket: socket, address: address}}
  end

  def init(_) do
    {:error, "invalid parameters"}
  end

  def handle_call({:get_state}, _from, state) do
    {:noreply, state, state}
  end

  def handle_call({:send_msg, msg}, from, %State{socket: socket} = state) do
    socket |> Socket.Stream.send!(msg)
    {:noreply, nil, %State{state | from: from}}
  end

  def handle_call({:read_msg}, from, %State{socket: socket} = state) do
    msg = socket |> Socket.Stream.recv!
    {:reply, msg, %State{state | from: from}}
  end

  def handle_call(msg, from, state) do
    IO.puts "handle_call"
    IO.inspect msg
    IO.inspect from
    IO.inspect state
  end

  def handle_cast(msg, state) do
    IO.puts "handle_cast"
    IO.inspect msg
    IO.inspect state
  end

  def handle_info(msg, state) do
    IO.puts "handle_info"
    IO.inspect msg
    IO.inspect state
  end
end
