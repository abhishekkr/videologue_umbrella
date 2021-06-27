defmodule VideologueWeb.Auth do
  import Plug.Conn
  alias Videologue.Accounts
  alias VideologueWeb.Router.Helpers, as: Routes

  @token_salt Application.get_env(:videologue, :phoenix_token_salt)

  def init(opts), do: opts

  def call(conn, _opts), do: do_call(conn, conn.assigns[:current_user])
  def do_call(conn, nil) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)
    assign(conn, :current_user, user)
    |> put_user_token(user)
  end
  def do_call(conn, user), do: put_user_token(conn, user)

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_user_token(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn), do: configure_session(conn, drop: true)

  def authenticate_user(conn, _opts), do: do_authenticate_user(conn, conn.assigns[:current_user])
  def do_authenticate_user(conn, nil) do
    conn
    |> Phoenix.Controller.put_flash(:error, "You are not logged in.")
    |> Phoenix.Controller.redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end
  def do_authenticate_user(conn, _current_user), do: conn

  defp put_user_token(conn, nil), do: assign(conn, :user_token, nil)
  defp put_user_token(conn, user) do
    token = Phoenix.Token.sign(conn, @token_salt, user.id)
    assign(conn, :user_token, token)
  end
end
