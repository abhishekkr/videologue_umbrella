defmodule VideologueWeb.Channels.VideoChannelTest do
  use VideologueWeb.ChannelCase, async: false
  import VideologueWeb.TestData

  @token_salt  Application.get_env(:videologue, :phoenix_token_salt)

  setup do
    user = insert_user(name: "Tester")
    video = insert_video(user, title: "Running Test")
    token = Phoenix.Token.sign(@endpoint, @token_salt, user.id)

    {:ok, socket} = connect(VideologueWeb.UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user, video: video}
  end

  test "join replies with video annotations",
      %{socket: socket, user: user, video: video} do
    ~w{this that}
    |> Enum.each(
      &(Videologue.Multimedia.annotate_video(user, video.id, %{body: &1, at: 0}))
    )

    {:ok, reply, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})
    assert video.id == socket.assigns.video_id
    assert %{annotations: [%{body: "this"}, %{body: "that"}]} = reply
  end

  test "insert new annotations", %{socket: socket, video: video} do
    {:ok, _reply, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})
    ref = push(socket, "new_annotation", %{body: "new note", at: 0})

    assert_reply ref, :ok, %{}
    assert_broadcast "new_annotation", %{}
  end

  test "new annotations triggers Nfo", %{socket: socket, video: video} do
    insert_user(username: "wolfram", password: "this is wolfram")
    {:ok, _reply, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})
    ref = push(socket, "new_annotation", %{body: "1 + 1", at: 10})

    assert_reply ref, :ok, %{}
    assert_broadcast "new_annotation", %{body: "1 + 1", at: 10}
    assert_broadcast "new_annotation", %{body: "2", at: 10}
  end
end
