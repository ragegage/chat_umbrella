defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel
  alias ChatWeb.User
  alias ChatWeb.Repo
  alias ChatWeb.Presence

  def join("room:" <> room_name, _message, socket) do
    ChatServer.Supervisor.start_room(room_name)
    chat_list = ChatServer.get(room_name)
    |> Enum.map(fn(message) ->
      case Map.get(message, :username) do
        "rage" -> Map.put(message, :prof, "../images/asdfqwer_color.png")
        _ -> Map.put(message, :prof, "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Dog-128.png")
      end
    end)
    send(self(), :after_join)
    {:ok, chat_list, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    "room:" <> room_name = socket.topic
    user = Repo.get!(User, socket.assigns.user)
    ChatServer.create(room_name, %{content: body, username: user.email})
    ChatServer.get(room_name)
    prof = case user.email do
      "rage" -> "../images/asdfqwer_color.png"
      _ -> "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Dog-128.png"
    end
    broadcast! socket, "new_msg", %{content: body,
                                    username: user.email,
                                    prof: prof
                                  }
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user, %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end
end
