defmodule ChatServer do
  use GenServer

  defmodule Message do
    defstruct content: "", username: "anon"
  end

  # Client functions
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: via_tuple(name))
  end

  def get(room_name) do
    GenServer.call(via_tuple(room_name), {:get})
  end

  def create(room_name, content) do
    GenServer.cast(via_tuple(room_name), {:create, content})
  end

  defp via_tuple(room_name) do
    {:via, Registry, {:chat_room, room_name}}
  end

  # Server functions
  def init(:ok) do
    # argument matches second argument from start_link
    {:ok, []}
  end

  def handle_cast({:create, 
                  %{content: content, 
                  username: username} = content}, state) do
    # {:noreply, new state}
    {:noreply, state ++ [content]}
  end
  def handle_cast({:create, content}, state) do
    # {:noreply, new state}
    {:noreply, state ++ [struct(%Message{}, %{content: content})]}
  end
  def handle_cast(request, state) do
    # if it doesn't match, call super
    super(request, state)
  end

  def handle_call({:get}, _from, state) do
    # {:reply, content of reply, state}
    {:reply, state, state}
  end
  def handle_call(request, from, state) do
    # if it doesn't match, call super
    super(request, from, state)
  end
end
