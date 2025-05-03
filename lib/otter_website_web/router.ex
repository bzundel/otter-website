defmodule OtterWebsiteWeb.Router do
  use OtterWebsiteWeb, :router

  import OtterWebsiteWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {OtterWebsiteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OtterWebsiteWeb do
    pipe_through :browser

    live_session :home,
      on_mount: [{OtterWebsiteWeb.UserAuth, :mount_current_user}] do

      live "/", Home.HomeLive
    end

    get "/posts/:identifier", Posts.PostsController, :details
  end

  # Other scopes may use custom stacks.
  # scope "/api", OtterWebsiteWeb do
  #   pipe_through :api
  # end

  ## Authentication routes

  scope "/", OtterWebsiteWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/admin/register", UserRegistrationController, :new
    post "/admin/register", UserRegistrationController, :create
    get "/admin/log_in", UserSessionController, :new
    post "/admin/log_in", UserSessionController, :create
  end

  scope "/", OtterWebsiteWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :admin,
      on_mount: [{OtterWebsiteWeb.UserAuth, :mount_current_user}] do

      live "/admin", Live.AdminLive
    end

    get "/admin/settings", UserSettingsController, :edit
    put "/admin/settings", UserSettingsController, :update
  end

  scope "/", OtterWebsiteWeb do
    pipe_through [:browser]

    delete "/admin/log_out", UserSessionController, :delete
  end
end
