# ChatServer

A simple, multi-room chat server that stores chat content using its `create/2` function and sends it back to the user via its `get/1` function.

## Usage:

1. `git clone`
1. `iex -S mix`
1. `ChatServer.Supervisor.start_link`
1. `ChatServer.Supervisor.start_room("lobby")`
1. `ChatServer.get("lobby") #=> []`
1. `ChatServer.create("lobby", "hello world")`
1. `ChatServer.get("lobby") #=> [%ChatServer.Message{content: "hello world", username: "anon"}]`