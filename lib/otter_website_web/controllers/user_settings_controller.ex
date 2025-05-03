defmodule OtterWebsiteWeb.UserSettingsController do
  use OtterWebsiteWeb, :controller

  alias OtterWebsite.Accounts
  alias OtterWebsiteWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, :edit, page_title: "Account settings")
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, ~p"/admin/settings")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, :edit, password_changeset: changeset)
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
