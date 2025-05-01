defmodule OtterWebsiteWeb.AdminController do
  use OtterWebsiteWeb, :controller

  def home(conn, _params) do
    render(conn, :admin)
  end
end
