defmodule OtterWebsiteWeb.PageController do
  alias OtterWebsite.Announcements
  use OtterWebsiteWeb, :controller

  def home(conn, _params) do
    posts = Announcements.all_posts()
    render(conn, :home, layout: false, posts: posts)
  end
end
