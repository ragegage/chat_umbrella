# Chat

This is an umbrella app combining a Phoenix web app with the ChatServer
app over at https://github.com/ragegage/chat_server.

The instructions for creating a chat app with Phoenix largely cover
creating the web portion of this app; the only parts that have changed
are the ChatWeb.RoomChannel module and the frontend code.

ChatWeb.RoomChannel now starts a link to the ChatServer.Supervisor and
starts a room whenever a user joins a room. If that room already
exists, the list of previous chats from that room are returned to the
frontend along with the socket.

The frontend only updates one handler from the other set of chat app
instructions: the response callback after a user joins a channel. The
frontend now receives all previous messages from that channel from the
backend, and so it adds each message to the unordered list of messages.