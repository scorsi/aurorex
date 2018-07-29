defmodule Aurorex.Client do
  use Connection

  require Logger

  @socket_opts [mode: :binary, active: false, packet: :raw]

  @timeout 5000

  defmodule State do
    defstruct socket: nil,
              pid: nil,
              username: nil,
              password: nil,
              address: %{host: nil, port: nil}
  end

  ## Client

  @spec connect(%State{}) :: Connection.on_start
  def connect(opts) do
    start_link(opts)
  end

  @spec start_link(Keyword.t()) :: Connection.on_start
  def start_link(opts) do
    case Connection.start_link(__MODULE__, opts, name: :aurorex) do
      {:ok, pid} -> {:ok, %State{Connection.call(pid, {:get_state}) | pid: pid}}
      {:error, _msg} = err -> err
    end
  end

  def send_msg(%State{pid: pid}, msg) do
    Connection.call(pid, {:send_msg, msg})
  end

  def read_msg(%State{pid: pid}) do
    Connection.call(pid, {:read_msg})
  end

  ## Callbacks

  def init(%State{address: %{host: host, port: port}} = state) do
    {:ok, socket} = :gen_tcp.connect(String.to_charlist(host), port, @socket_opts)
    {:ok, %State{state | socket: socket}}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:send_msg, msg}, _from, %State{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, msg)
    {:reply, :ok, state}
  end

  def handle_call({:read_msg}, _from, %State{socket: socket} = state) do
    {:ok, msg} = :gen_tcp.recv(socket, 0)
    {:reply, msg, state}
  end

  def handle_call(msg, from, state) do
    IO.puts("handle_call")
    IO.inspect(msg)
    IO.inspect(from)
    IO.inspect(state)
    {:noreply, msg, state}
  end

  def handle_cast(msg, state) do
    IO.puts("handle_cast")
    IO.inspect(msg)
    IO.inspect(state)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts("handle_info")
    IO.inspect(msg)
    IO.inspect(state)
    {:noreply, state}
  end
end
