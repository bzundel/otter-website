defmodule OtterWebsiteWeb.UserSessionController do
  use OtterWebsiteWeb, :controller

  alias OtterWebsite.Accounts
  alias OtterWebsiteWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil, page_title: "Log in")
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :new, error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
