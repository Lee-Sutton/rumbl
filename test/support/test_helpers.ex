defmodule Rumbl.TestHelpers do
  alias Rumbl.{
    Accounts,
    Multimedia
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some user",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "supersecret",
      })
      |> Accounts.register_user()

    user
  end

  def video_fixture(user, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{
        title: "A title",
        url: "https://example.com",
        description: "Some user",
      })

    {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end
end
