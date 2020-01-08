defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category
  alias Rumbl.Multimedia.Video

  describe "categories" do
    test 'list_alphabetical_categories' do
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

  describe "videos" do
    @valid_attrs %{description: "desc", title: "fancy title", url: "http://local"}
    @invalid_attrs %{description: nil, title: nil, url: nil}

    setup do
      {:ok, owner: user_fixture()}
    end

    test "list videos/0 return all videos", %{owner: owner} do
      %Video{id: id1} = video_fixture(owner)

      assert [%Video{id: ^id1}] = Multimedia.list_videos()

      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with given id", %{owner: owner} do
      %Video{id: id} = video_fixture(owner)

      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/2 with valid data creates video", %{owner: owner} do
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs)

      assert video.description == "desc"
      assert video.title == "fancy title"
      assert video.url == "http://local"
    end

    test "create_video/2 with valid data creates video with slug", %{owner: owner} do
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs)
      assert video.slug == "fancy-title"
    end

    test "create_video/2 with invalid data returns error changes", %{owner: owner} do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid params updates video", %{owner: owner} do
      video = video_fixture(owner)

      assert {:ok, video } = Multimedia.update_video(video, %{title: "new title"})
      assert %Video{} = video
      assert video.title == "new title"
      assert video.slug == "new-title"
    end

    test "update_vide/2 with invalid params returns error changes", %{owner: owner} do
      %Video{id: id} = video = video_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)

      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "delete_video/1 deletes the video", %{owner: owner} do
      video = video_fixture(owner)
      assert {:ok, %Video{}} = Multimedia.delete_video(video)

      assert [] = Multimedia.list_videos()
    end

    test "change_video/1 return a video changeset", %{owner: owner} do
      video = video_fixture(owner)

      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end
end
