defmodule VideologueWeb.TestData do
  def insert_user(attrs \\ %{}) do
    {:ok, user} = attrs
                  |> Enum.into(default_user())
                  |> Videologue.Accounts.register_user()
    user
  end

  def insert_video(user, attrs \\ %{}) do
    video_fields = Enum.into(attrs, default_video())
    {:ok, video} = Videologue.Multimedia.create_user_video(user, video_fields)
    video
  end

  def login(%{conn: conn, login_as: username}) do
    user = insert_user(username)
    {Plug.Conn.assign(conn, :current_user, user), user}
  end
  def login(%{conn: conn}), do: {conn, :logged_out}

  defp default_user do
    %{name: "Test UserX",
      username: "testuser#{System.unique_integer([:positive])}",
      password: "secret-good-for-validation"}
  end

  defp default_video do
    %{url: "https://vi.de/o",
      description: "some video",
      body: "baahdee"}
  end
end
