defmodule Aurorex.Connector.Client do
  use Connection

  require Logger

  @socket_opts [:binary, active: false, packet: :raw]

  defmodule State do
    defstruct socket: nil,
              pid: nil,
              session_id: nil,
              opts: [],
              protocol_version: nil
  end

  ## Client

  @spec start_link(Keyword.t) :: Connection.on_start
  def start_link(opts) do
    case Connection.start_link(__MODULE__, opts, name: :aurorex) do
      {:ok, _pid} = res -> res
      {:error, _msg} = err -> err
    end
  end

  def send_msg(%State{pid: pid}, msg) do
    Connection.call(pid, {:send_msg, msg})
  end

  def read_msg(%State{pid: pid}) do
    msg = Connection.call(pid, {:read_msg})
    {:ok, msg}
  end

  ## Callbacks

  def init(state) do
    {:ok, socket} = :gen_tcp.connect('localhost', 2424, @socket_opts)
    {:ok, %{state | socket: socket, pid: self()}}
  end

  # def init([host: host, port: port] = address) do
  #   socket = Socket.TCP.connect!(host, port)
  #   {:ok, %State{socket: socket, address: address}}
  # end

  # def init(_) do
  #   {:error, "invalid parameters"}
  # end

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
