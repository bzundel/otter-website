defmodule OtterWebsiteWeb.Live.AdminLive do
  import Ecto.Query

  alias OtterWebsite.Accounts
  alias OtterWebsite.Meetups
  alias OtterWebsite.Meetups.Meetup
  alias OtterWebsite.Accounts.InvitationKey
  alias OtterWebsite.Repo

  use OtterWebsiteWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl px-2">
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
                <div class="flex flex-col md:flex-row justify-between grow bg-gray-100 rounded-xl p-2">
                  {Calendar.strftime(meetup.date, "%a, %d. %B %Y, %I:%M %p")}
                  <span>{meetup.room}</span>
                  <!-- TODO show some indication if meetup is in the past (or don't show at all) -->
                </div>
                <.button class="bg-zinc-600 hover:bg-zinc-700 my-auto"
                  phx-click="show_meetup_details_modal"
                  phx-value-id={meetup.id}>
                  <.icon name="hero-magnifying-glass"/>
                </.button>
                <.button class="bg-red-600 hover:bg-red-700 my-auto"
                  phx-click="show_confirm_delete_item_dialog"
                  phx-value-id={meetup.id}
                  phx-value-message="Are you sure you want to delete this meetup?"
                  phx-value-type={Meetup}>
                  <.icon name="hero-trash"/>
                </.button>
              </div>
            <% end %>
          <% end %>

        </div>

        <div class="flex flex-col gap-y-4 w-full">
          <span class="text-md font-bold">Invitation keys</span>
          <.button phx-click="generate_new_key">Generate key</.button>

          <%= for key <- @keys do %>
            <div class="flex gap-x-2">
              <div class="flex flex-col md:flex-row items-cetner justify-between bg-gray-100 rounded-xl p-2 grow">
                <div class="flex gap-x-2">
                  <span class="text-sm font-bold inline md:hidden">Key:</span>
                  <span class="text-sm">{key.key}</span>
                </div>

                <div class="flex gap-x-2">
                  <span class="text-sm font-bold inline md:hidden">Used by:</span>
                  <%= if is_nil(key.used_by) do %>
                    <span class="text-sm">-</span>
                  <% else %>
                    <span class="text-sm">{key.used_by}</span>
                  <% end %>
                </div>
              </div>
              <.button class="my-auto"
                phx-click="show_confirm_delete_item_dialog"
                phx-value-id={key.id}
                phx-value-type={InvitationKey}
                phx-value-message="Are you sure you want to delete this invitation key?">
                <.icon name="hero-trash"/>
              </.button>
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

    <.modal :if={@show_meetup_details_modal} id="meetup_details-modal" show on_cancel={JS.push("close_meetup_details_modal")}>
      <.live_component
        module={OtterWebsiteWeb.Admin.Dialogs.MeetupDetailsDialog}
        id="meetup-details-dialog"
        meetup_id={@meetup_details_id}
      />
    </.modal>

    <.modal :if={@show_confirm_delete_modal} id="confirm-delete-modal" show on_cancel={JS.push("close_confirm_delete_modal")}>
      <.live_component
        module={OtterWebsiteWeb.Dialogs.ConfirmDialog}
        id="confirm-delete-dialog"
        title={@confirm_delete_message}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    meetups = Meetups.list_meetups_in_order()
    keys = Accounts.list_invitation_keys()
    socket =
      socket
      |> assign(:page_title, "Admin board")
      |> assign(:meetups, meetups)
      |> assign(:keys, keys)
      |> assign(:show_create_meetup_modal, false)
      |> assign(:show_meetup_details_modal, false)
      |> assign(:show_confirm_delete_modal, false)
      |> assign(:confirm_delete_message, "")
      |> assign(:item_id_to_delete, nil)
      |> assign(:meetup_details_id, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("generate_new_key", _params, socket) do
    value = UUID.uuid4()
    case Repo.insert(%InvitationKey{key: value}) do
      {:ok, key} ->
        socket =
          socket
          |> reloader(InvitationKey)
          |> put_flash(:info, "Key generated successfully")
        {:noreply, socket}
      {:error, _} -> {:noreply, put_flash(socket, :error, "Something went wrong while generating a new key")}
    end
  end

  # FIXME obsolete code found! will (probably if i don't forget) remove in next cleanup :)
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
      |> reloader(Meetup)
    {:noreply, socket}
  end

  # Show meetup details
  def handle_event("show_meetup_details_modal", %{"id" => id}, socket) do
    socket =
      socket
      |> assign(:show_meetup_details_modal, true)
      |> assign(:meetup_details_id, id)

    {:noreply, socket}
  end

  def handle_event("close_meetup_details_modal", _params, socket) do
    {:noreply, assign(socket, :show_meetup_details_modal, false)}
  end

  def handle_info(:close_meetup_details_modal, socket) do
    {:noreply, assign(socket, :show_meetup_details_modal, false)}
  end

  # Confirm delete
  def handle_event("show_confirm_delete_item_dialog", %{"id" => id, "type" => type, "message" => message}, socket) do
    socket =
      socket
      |> assign(:confirm_delete_message, message)
      |> assign(:show_confirm_delete_modal, true)
      |> assign(:item_id_to_delete, id)
      |> assign(:item_type_to_delete, type)
    {:noreply, socket}
  end

  def handle_event("close_confirm_delete_modal", _params, socket) do
    {:noreply, assign(socket, :show_confirm_delete_modal, false)}
  end

  @impl true
  def handle_info({OtterWebsiteWeb.Dialogs.ConfirmDialog, value}, socket) do
    module = socket.assigns.item_type_to_delete |> String.split(".") |> Module.concat()
    socket =
      case value do
        true ->
          id = String.to_integer(socket.assigns.item_id_to_delete)

          case Repo.one(from item in module, where: item.id == ^id) do
            nil -> put_flash(socket, :error, "Something went wrong while trying to delete the item")
            item ->
              Repo.delete(item)
              put_flash(socket, :info, "Successfully deleted item")
          end

        false ->
          socket
      end

    socket =
      socket
      |> assign(:show_confirm_delete_modal, false)
      |> assign(:item_id_to_delete, nil)
      |> assign(:item_type_to_delete, nil)
      |> reloader(module)

    {:noreply, socket}
  end

  defp reloader(socket, Meetup), do: assign(socket, :meetups, Meetups.list_meetups_in_order())
  defp reloader(socket, InvitationKey), do: assign(socket, :keys, Accounts.list_invitation_keys())
  defp reloader(socket, _), do: socket
end
