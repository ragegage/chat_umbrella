defmodule ChatWeb.Router do
  use ChatWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug SimpleAuth.CurrentUser
    plug :put_user_token
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
        handler: ChatWeb.GuardianErrorHandler
  end

  scope "/", ChatWeb do
    pipe_through [:browser, :with_session] # Use the default browser stack

    scope "/" do
      pipe_through [:login_required]
      get "/chat", PageController, :index
    end

    get "/", SessionController, :new
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatWeb do
  #   pipe_through :api
  # end

  # assigns a user token
  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
