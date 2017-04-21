# Chat

This is an umbrella app combining a Phoenix web app with the ChatServer
app (https://github.com/ragegage/chat_server) and basic authentication 
(https://github.com/ragegage/phoenix_auth). The chat server allows users
to create and join chat rooms and post messages to those rooms. The 
messages are stored in memory, rather than persisted to a database.

To run locally: 

+ `git clone`
+ `cd chat_umbrella`
+ `mix phoenix.server`
+ Navigate to localhost:4000 and sign up to access the chat service

Instructions for creating a basic version of this app (the version on the 
`no-auth` branch) can be found at
https://github.com/ragegage/elixir_lectures/blob/master/phoenix_umbrella.md.

## Future development goals:

- [X] standard anonymous profile picture
- [X] Giphy integration
- [X] "ding" when new message is received (as per user request)
- [X] can change chat room by clicking on chat room name
- [ ] allow users to upload real profile pictures
- [ ] add support for emoji
- [ ] allow users to directly message each other
