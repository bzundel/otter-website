defmodule OtterWebsiteWeb.Posts.PostsController do
  alias OtterWebsiteWeb.ErrorHTML
  alias OtterWebsite.Announcements
  use OtterWebsiteWeb, :controller

  def details(conn, %{"identifier" => identifier}) do
    case Announcements.get_post_by_identifier!(identifier) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(ErrorHTML, "404.html")
        |> halt()
      post ->
        render(conn, :post_details, post: post, page_title: post.title)
    end
  end
end
