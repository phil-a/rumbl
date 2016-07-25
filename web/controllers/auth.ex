defmodule  Rumbl.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Rumbl.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo) # take options and extract repo
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id) # checks if user_id stored in session
    user = user_id && repo.get(Rumbl.User, user_id)
    assign(conn, :current_user, user) # assign it to current user for use downstream
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    # fetch repo from opts and get user by username
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Rumbl.User, username: username)

    cond do
      # user and pass match
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      # pass doesn't match
      user ->
        {:error, :unauthorized, conn}
      # user isn't found (protect against timing attacks)
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

end
