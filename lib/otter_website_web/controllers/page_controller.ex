defmodule OtterWebsiteWeb.PageController do
  alias OtterWebsite.Meetups
  alias OtterWebsite.Announcements
  use OtterWebsiteWeb, :controller

  def home(conn, _params) do
    next_meetup = Meetups.get_upcoming_meetup()
    posts = Announcements.all_posts()
    render(conn, :home, posts: posts, next_meetup: next_meetup)
  end
end
