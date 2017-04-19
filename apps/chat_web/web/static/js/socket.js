// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let socket

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

let setupSocket = (socket) => {
  socket.connect()

  // Now that you are connected, you can join channels with a topic:
  let channel
  let newChannel = socket.channel("room:lobby", {})

  let chatInput = document.querySelector("#chat-input")
  let messagesContainer = document.querySelector("#chat-list")
  let roomInput = document.querySelector("#room-input")
  let roomTitle = document.querySelector("#chat-room-title")
  let roomsContainer = document.querySelector("#room-list")
  let userCount = document.querySelector("#user-count")

  let loadMessages = resp => {
    // clear out message container ul
    messagesContainer.innerHTML = ''
    // put messages (previous messages in the channel) into the ul
    resp.forEach(msg => {
      let messageItem = document.createElement("li");
      messageItem.innerHTML = formatMessage(msg.username, msg.content, msg.prof)
      messagesContainer.appendChild(messageItem)
    })
  }

  let joinRoomOnClick = (e) => {
    setupChannel(e.currentTarget.innerText)
  }

  let joinChannel = (newChannel, channelName) => {
    if(channel) {
      channel.leave()
    }
    channel = newChannel
    channel.join()
      .receive("ok", resp => {
        for (var i = 0; i < roomsContainer.children.length; i++)
          if(roomsContainer.children[i].innerText === channelName)
            roomsContainer.removeChild(roomsContainer.children[i])
        
        let roomItem = document.createElement("li")
        roomItem.innerText = `${channelName}`
        roomItem.addEventListener('click', joinRoomOnClick)
        roomsContainer.appendChild(roomItem)
        roomTitle.innerText = `${channelName}`
        loadMessages(resp)
        roomInput.value = ''
      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      })
  }

  chatInput.addEventListener("keypress", event => {
    if(event.keyCode === 13){
      channel.push("new_msg", {body: chatInput.value})
      chatInput.value = ""
    }
  })

  let channelOnMessage = channel => {
    channel.on("new_msg", payload => {
      playSound()
      let messageItem = document.createElement("li")
      messageItem.innerHTML = formatMessage(payload.username, payload.content, payload.prof)
      messagesContainer.appendChild(messageItem)
      messageItem.scrollIntoView()
    })
  }

  let playSound = () => {
    new Audio('./images/ding.mp3').play()
  }

  let channelOnPresence = channel => {
    channel.on("presence_state", payload => {
      console.log(payload);
      userCount.innerText = Object.keys(payload).length
    })
    channel.on("presence_diff", diff => {
      console.log("diff");
      console.log(diff);
      userCount.innerText = (parseInt(userCount.innerText) +
        Object.keys(diff.joins).length - Object.keys(diff.leaves).length)
    })
  }

  let formatMessage = (name, content, prof) => {
    const d = new Date()
    let h = d.getHours()
    let m = d.getMinutes()
    m = m < 10 ? "0" + m : m
    const ampm = h > 11 ? "PM" : "AM"
    h = h == 0 ? 12 : h % 12

    return `<prof style="background-image: url(${prof})"></prof>
    <name>${name}</name>
    <time>${h}:${m} ${ampm}</time>
    <msg>${content}</msg>`
  }


  roomInput.addEventListener("keypress", event => {
    if(event.keyCode === 13){
      setupChannel(roomInput.value)
    }
  })

  let setupChannel = (channelName) => {
    let newChannel = socket.channel(`room:${channelName}`, {})
    joinChannel(newChannel, channelName)
    channelOnMessage(newChannel)
    channelOnPresence(newChannel)
  }

  setupChannel("lobby")
  return socket
}

if (window.userToken !== "") {
  debugger
  socket = setupSocket(new Socket("/socket", {params: {token: window.userToken}}))
}

export default socket
