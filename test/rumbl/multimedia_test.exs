defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category
  alias Rumbl.Multimedia.Video

  describe "categories" do
    test "list alphabetical categories" do
      for name <- ~w(Drama Action Comedy) do
        Multimedia.create_category!(name)
      end

      alpha_names =
        for %Category{name: name} <- Multimedia.list_alphabetical_categories() do
          name
        end

      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos test suite" do
    @valid_attrs %{
      description: "desc",
      title: "title",
      url: "http://examplevid.com"
    }

    @invalid_attrs %{
      description: nil,
      title: nil,
      url: nil
    }

    test "list_videos/0 returns all videos" do
      owner = user_fixture()
      %Video{id: id1} = video_fixture(owner, @valid_attrs)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with the given id" do
      owner = user_fixture()
      %Video{id: id} = video_fixture(owner, @valid_attrs)

      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/2 with valid data creates a video" do
      owner = user_fixture()
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs)
    end

    test "create_video/2 with invalid data does not create a video" do
      owner = user_fixture()
      assert {:error, _changeset} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      owner = user_fixture()
      video = video_fixture(owner, @valid_attrs)
      assert {:ok, %Video{} = video} = Multimedia.update_video(video, %{title: "new title"})
      assert video.title == "new title"
    end

    test "update_video/2 with invalid data returns an error changeset" do
      owner = user_fixture()
      video = video_fixture(owner, @valid_attrs)
      assert {:error, changeset} = Multimedia.update_video(video, %{title: nil})
      assert "can't be blank" in errors_on(changeset).title
    end

    test "delete_video/1 deletes a video" do
      owner = user_fixture()
      video = video_fixture(owner)
      assert {:ok, %Video{}} = Multimedia.delete_video(video)

      assert Multimedia.list_videos() == []
    end

    test "change_video/2 returns a video changeset" do
      owner = user_fixture()
      video = video_fixture(owner)
      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end
end
