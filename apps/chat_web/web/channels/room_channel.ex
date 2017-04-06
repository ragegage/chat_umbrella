defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel
  alias ChatWeb.User
  alias ChatWeb.Repo

  def join("room:" <> room_name, _message, socket) do
    ChatServer.Supervisor.start_room(room_name)
    chat_list = ChatServer.get(room_name)
    {:ok, chat_list, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    "room:" <> room_name = socket.topic
    user = Repo.get!(User, socket.assigns.user)
    ChatServer.create(room_name, %{content: body, username: user.email})
    ChatServer.get(room_name)
    broadcast! socket, "new_msg", %{content: body, username: user.email}
    {:noreply, socket}
  end
end
