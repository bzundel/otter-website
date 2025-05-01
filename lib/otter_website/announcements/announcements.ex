defmodule OtterWebsite.Announcements do
  alias OtterWebsite.Announcements.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:otter_website, "priv/posts/*.md"),
    as: :posts,
    highlighters: []

  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  def all_posts, do: @posts
  def all_tags, do: @tags
end
