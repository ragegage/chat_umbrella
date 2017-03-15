# Chat

This is an umbrella app combining a Phoenix web app with the ChatServer
app over at https://github.com/ragegage/chat_server.

## Combining the two apps

`mix new Chat --umbrella`

Move the ChatServer app into the `apps` folder in the new Chat app.

## Build a Chat Web App

The instructions for creating a chat app with Phoenix largely cover
creating the web portion of this app; the only parts that have changed
are the ChatWeb.RoomChannel module and the frontend code.

## Modify the Chat Web App

ChatWeb.RoomChannel now starts a link to the ChatServer.Supervisor and
starts a room whenever a user joins a room. If that room already
exists, the list of previous chats from that room are returned to the
frontend along with the socket.

The frontend only updates one handler from the other set of chat app
instructions: the response callback after a user joins a channel. The
frontend now receives all previous messages from that channel from the
backend, and so it adds each message to the unordered list of messages.

## Add room creation

Next, let's implement the ChatServer feature where users can create
their own chat rooms named whatever they want.

To do this, we'll need a way for users of our web app to input a chat
room name, and tell our server to let people join whatever room they
want.

## TODO: Display list of rooms

Next, let's keep a list of rooms on the page at all times. A room will get added to the list once the user has joined it.

## TODO: Display list of online users (using Presence)

## TODO: Track idle-ness of online users (??)