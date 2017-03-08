defmodule ChatWeb.PageController do
  use ChatWeb.Web, :controller

  def index(conn, _params) do
    ChatServer.Supervisor.start_link
    ChatServer.Supervisor.start_room("gage")
    ChatServer.create("gage", "hello world")
    [chat | t] = ChatServer.get("gage")
    IO.inspect chat
    render conn, 
      "index.html", 
      content: chat.content,
      username: chat.username
  end
end
