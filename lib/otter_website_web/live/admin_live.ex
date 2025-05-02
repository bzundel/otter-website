defmodule OtterWebsiteWeb.Live.AdminLive do
  import Ecto.Query

  alias OtterWebsite.Meetups
  alias OtterWebsite.Meetups.Meetup
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
          <span class="text-md font-bold">Meetups</span>
          <.button phx-click="show_create_meetup_modal">Create meetup</.button>

          <%= if Enum.empty?(@meetups) do %>
            <span class="text-center text-gray-600">No meetups found</span>
          <% else %>
            <%= for meetup <- @meetups do %>
              <div class="flex gap-x-2">
                <div class="flex justify-between grow bg-gray-100 rounded-xl p-2">
                  {Calendar.strftime(meetup.date, "%a, %d. %B %Y, %I:%M %p")}
                  <span>{meetup.room}</span>
                  <!-- TODO show some indication if meetup is in the past (or don't show at all) -->
                </div>
                <.button class="bg-zinc-600 hover:bg-zinc-700">Show</.button>
                <.button class="bg-red-600 hover:bg-red-700">Delete</.button>
              </div>
            <% end %>
          <% end %>

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

    <.modal :if={@show_create_meetup_modal} id="create-appointment-modal" show on_cancel={JS.push("close_create_meetup_modal")}>
      <.live_component
        module={OtterWebsiteWeb.Admin.Dialogs.CreateMeetupDialog}
        id="create-appointment-dialog"
        title="Create new meetup"
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    meetups = Meetups.list_meetups_in_order()
    keys = Repo.all(InvitationKey)
    socket =
      socket
      |> assign(:meetups, meetups)
      |> assign(:keys, keys)
      |> assign(:show_create_meetup_modal, false)

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

  # Create meetup events
  def handle_event("show_create_meetup_modal", _params, socket) do
    {:noreply, assign(socket, :show_create_meetup_modal, true)}
  end

  def handle_event("close_create_meetup_modal", _params, socket) do
    {:noreply, assign(socket, :show_create_meetup_modal, false)}
  end

  @impl true
  def handle_info(:close_create_meetup_modal, socket) do
    socket =
      socket
      |> assign(:show_create_meetup_modal, false)
      |> assign(:meetups, Meetups.list_meetups_in_order) # FIXME use update/3 here?
    {:noreply, socket}
  end
end
