require IEx

defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> room_name, _message, socket) do
    ChatServer.Supervisor.start_room(room_name)
    chat_list = ChatServer.get(room_name)
    {:ok, chat_list, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    "room:" <> room_name = socket.topic
    ChatServer.create(room_name, body)
    ChatServer.get(room_name)
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end
end
