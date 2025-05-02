defmodule OtterWebsiteWeb.Live.AdminLive do
  import Ecto.Query

  alias OtterWebsite.Accounts.InvitationKey
  alias OtterWebsite.Repo

  use OtterWebsiteWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl">
      <div class="flex flex-col gap-y-8 items-center my-4 w-full">
        <span class="text-xl font-bold">Admin Board</span>

        <div class="flex flex-col gap-y-4 w-full">
          <span class="text-md font-bold">Appointments</span>
        </div>

        <div class="flex flex-col gap-y-4 w-full">
          <span class="text-md font-bold">Invitation keys</span>
          <.button phx-click="generate_new_key">Generate key</.button>

          <%= for key <- @keys do %>
            <div class="flex items-center justify-around bg-gray-100 rounded-xl p-2 gap-x-8">
              <span class="text-sm font-bold">{key.key}</span>

              <%= if is_nil(key.used_by) do %>
                <span class="text-sm">-</span>
                <.button phx-click="delete_key" phx-value-id={key.id}>Delete</.button>
              <% else %>
                <span class="text-sm font-bold">{key.used_by}</span>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    keys = Repo.all(InvitationKey)
    socket = assign(socket, :keys, keys)

    {:ok, socket}
  end

  @impl true
  def handle_event("generate_new_key", _params, socket) do
    value = UUID.uuid4()
    case Repo.insert(%InvitationKey{key: value}) do
      {:ok, key} ->
        socket =
          socket
          |> assign(:keys, socket.assigns.keys ++ [key])
          |> put_flash(:info, "Key generated successfully")
        {:noreply, socket}
      {:error, _} -> {:noreply, put_flash(socket, :error, "Something went wrong while generating a new key")}
    end
  end

  @impl true
  def handle_event("delete_key", %{"id" => id}, socket) do
    case Repo.one(from ik in InvitationKey, where: ik.id == ^id and is_nil(ik.used_by)) do
      nil -> {:noreply, put_flash(socket, :error, "Invalid key to delete")}
      key ->
        case Repo.delete(key) do
          {:ok, _} ->
            socket =
              socket
              |> assign(:keys, Repo.all(InvitationKey))
              |> put_flash(:info, "Successfully deleted key")
            {:noreply, socket}
          {:error, _} -> {:noreply, put_flash(socket, :error, "An error occurred while attempting to delete the key")}
        end
    end
  end
end
