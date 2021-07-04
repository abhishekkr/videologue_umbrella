defmodule VideologueWeb.Channels.UserSocketTest do
  use VideologueWeb.ChannelCase, async: true
  alias VideologueWeb.UserSocket

  @token_salt  Application.get_env(:videologue, :phoenix_token_salt)

  test "socket auth with valid token" do
    token = Phoenix.Token.sign(@endpoint, @token_salt, "testx")

    assert {:ok, socket} = connect(UserSocket, %{"token" => token})
    assert socket.assigns.user_id == "testx"
  end

  test "socket auth with invalid token" do
    assert :error = connect(UserSocket, %{"token" => "anything"})
    assert :error = connect(UserSocket, %{})
  end
end
