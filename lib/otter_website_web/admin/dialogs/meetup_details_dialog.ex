defmodule OtterWebsiteWeb.Admin.Dialogs.MeetupDetailsDialog do
  use OtterWebsiteWeb, :live_component

  alias OtterWebsite.Meetups.Meetup
  alias OtterWebsite.Meetups
  alias OtterWebsite.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-4">
      <span class="text-md font-bold">Details of meetup on {Calendar.strftime(@meetup.date, "%a, %d. %B %Y, %I:%M %p")}</span>

      <div class="flex flex-col gap-y-4">
        <span class="text-sm font-bold">Registered talks</span>
          <%= if Enum.empty?(@meetup.talks) do %>
            <span class="text-center text-gray-600">No talks registered yet</span>
          <% else %>
            <div class="flex flex-col gap-y-2">
              <%= for talk <- @meetup.talks do %>
                <div class="flex gap-x-2">
                  <div class="flex justify-between grow bg-gray-100 rounded-xl p-2">
                    <span class="font-semibold">{talk.title}</span>
                    <span>{talk.author}</span>
                  </div>
                  <.button class="bg-red-600 hover:bg-red-700" phx-click="delete_talk" phx-value-id={talk.id} phx-target={@myself}>
                    Delete
                  </.button>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>

      <div class="flex flex-col gap-y-4">
        <span class="text-sm font-bold">Publish to mastodon</span>
        <!-- TODO implement publishing -->
        <!-- instead of having another modal plop up, show a preview of the toot here -->
        <.button>Publish</.button>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:page_title, "Meetup details")

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    meetup = Meetups.get_meetup!(assigns.meetup_id)

    {:ok, assign(socket, :meetup, meetup)}
  end

  @impl true
  def handle_event("delete_talk", %{"id" => id}, socket) do
    talk = Meetups.get_talk!(id)
    Repo.delete(talk)
    meetup = Meetups.get_meetup!(socket.assigns.meetup.id) # FIXME surely there is a hotter way to refresh the list

    {:noreply, assign(socket, :meetup, meetup)}
  end
end
