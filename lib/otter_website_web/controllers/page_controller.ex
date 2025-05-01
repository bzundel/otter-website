defmodule OtterWebsiteWeb.PageController do
  use OtterWebsiteWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
