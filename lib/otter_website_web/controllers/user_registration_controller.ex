defmodule OtterWebsiteWeb.UserRegistrationController do
  use OtterWebsiteWeb, :controller

  alias OtterWebsite.Accounts
  alias OtterWebsite.Accounts.User
  alias OtterWebsiteWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset, page_title: "Register")
  end

  def create(conn, %{"user" => user_params}) do
    IO.inspect(user_params)
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        Accounts.mark_invitation_key_used(user_params["invitation_key"], user)
        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, page_title: "Register")
    end
  end
end
