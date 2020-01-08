defmodule RumblWeb.VideoViewTest do
  use RumblWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    category = %Rumbl.Multimedia.Category{id: "1", name: "Drama"}
    videos = [
      %Rumbl.Multimedia.Video{id: "1", title: "dogs", category: category},
      %Rumbl.Multimedia.Video{id: "2", title: "cats", category: category}
    ]

    content = render_to_string(
      RumblWeb.VideoView,
      "index.html",
      conn: conn,
      videos: videos
    )

    assert String.contains?(content, "Listing Videos")

    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Rumbl.Multimedia.change_video(%Rumbl.Multimedia.Video{})
    categories = [%Rumbl.Multimedia.Category{id: 123, name: "cats"}]

    content =
      render_to_string(
        RumblWeb.VideoView, 
        "new.html",
        conn: conn,
        categories: categories,
        changeset: changeset
      )

    assert String.contains?(content, "New Video")
  end
end
