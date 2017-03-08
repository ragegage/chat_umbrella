defmodule ChatServer.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :chat_supervisor)
  end

  def start_room(name) do
    Supervisor.start_child(:chat_supervisor, [name])
  end

  def init(:ok) do
    Registry.start_link(:unique, :chat_room)

    children = [
      worker(ChatServer, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end