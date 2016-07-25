defmodule  Rumbl.Auth do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo) # take options and extract repo
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id) # checks if user_id stored in session
    user = user_id && repo.get(Rumbl.User, user_id)
    assign(conn, :current_user, user) # assign it to current user for use downstream
  end

end
