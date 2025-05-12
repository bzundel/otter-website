defmodule OtterWebsiteWeb.Home.HomeLive do
  use OtterWebsiteWeb, :live_view

  alias OtterWebsite.Meetups
  alias OtterWebsite.Announcements

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-12 p-x-8 mb-4">
      <div class="w-screen bg-gray-200 flex flex-col md:flex-row items-center justify-center md:gap-12">
        <img src="/images/logo.png" class="w-48"/>
        <div class="text-center py-4 md:py-12 w-80">
          <h1 class="text-4xl font-extrabold">OTTER</h1>
          <h1 class="text-xl">Free/libre and open source software group at the Frankfurt University of Applied Sciences</h1>
        </div>
      </div>

      <div class="w-screen flex flex-col items-center justify-center gap-y-4 px-2">
        <h1 class="text-xl font-semibold">Next meetup</h1>
          <div class="bg-gray-100 rounded-xl p-4 flex flex-col shadow-lg">
            <%= if is_nil(@next_meetup) do %>
              <span class="text-gray-600">No upcoming meetup</span>
            <% else %>
              <span class="text-lg font-semibold">{Calendar.strftime(@next_meetup.date, "%A, %Y-%m-%d at %I:%M %p")}</span>
              <span class="">Room: {@next_meetup.room}</span>
              <.button phx-click="show_register_talk_modal" class="m-2">Register a talk</.button>
            <% end %>
          </div>
      </div>

      <div class="flex flex-col items-center justify-center gap-y-2 px-2">
        <h1 class="text-xl font-semibold">Who are we?</h1>
        <div class="max-w-2xl text-justify">
          We are a group of people who agree with and support the principles of libre software. To spread the idea and create a room for people interested in the philosophy, we founded OTTER, a free/libre and open source software group at the Frankfurt University of Applied Sciences. Anyone who wants to learn about the movement, share some experiences, work on some open projects together, meet some like-minded people or just talk about nerdy things is welcome to come to our regular meetups!
        </div>
      </div>

      <div class="w-screen flex flex-col items-center justify-center gap-y-4 bg-gray-100 p-4">
        <span class="text-xl font-semibold">Connect with us</span>
        <div class="flex flex-col gap-y-2">
          <a href="https://matrix.to/#/!sUiINDKClsGLGRKAVI:matrix.org?via=matrix.org">
            <div class="bg-white hover:scale-105 transition duration-300 rounded-xl flex items-center gap-x-4 p-2 shadow">
              <img src="/images/matrix.svg" class="h-12"/>
              <span class="font-bold">FRA-UAS FLOSS-Meetup Room</span>
            </div>
          </a>

          <a href="https://hessen.social/@otter">
            <div class="bg-white hover:scale-105 transition duration-300 rounded-xl flex items-center gap-x-4 p-2 shadow">
              <img src="/images/mastodon.svg" class="h-12"/>
              <span class="font-bold">otter@hessen.social</span>
            </div>
          </a>
        </div>
      </div>

      <div class="w-screen flex flex-col items-center justify-center gap-y-4 px-4 mb:px-12 mb-2">
        <span class="text-xl font-semibold">Posts</span>

        <%= for post <- @posts do %>
          <a href={~p"/posts/#{post.identifier}"} class="bg-gray-100 hover:bg-gray-200 transition duration-300 rounded-xl p-4 w-full shadow">
            <div class="flex flex-col md:flex-row md:justify-between">
                <div class="flex flex-col md:flex-row md:gap-x-2">
                  <span class="text-gray-600">{Calendar.strftime(post.datetime, "%Y-%m-%d %I:%M %p")}</span>
                  <span class="font-bold">{post.title}</span>
                </div>
                <span>{post.author}</span>
            </div>
            <hr class="my-2"/>
            <span>{post.description}</span>
          </a>
        <% end %>
      </div>
    </div>

    <.modal :if={@show_register_talk_modal} id="register-talk-modal" show on_cancel={JS.push("close_register_talk_modal")}>
      <.live_component
        module={OtterWebsiteWeb.Home.Dialogs.RegisterTalkDialog}
        id="register-talk-dialog"
        title="Register a talk"
        meetup_id={@next_meetup.id}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    next_meetup = Meetups.get_upcoming_meetup()
    posts = Announcements.all_posts()
    socket =
      socket
      |> assign(:page_title, "Home")
      |> assign(:next_meetup, next_meetup)
      |> assign(:posts, posts)
      |> assign(:show_register_talk_modal, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("show_register_talk_modal", _params, socket) do
    {:noreply, assign(socket, :show_register_talk_modal, true)}
  end

  def handle_event("close_register_talk_modal", _params, socket) do
    {:noreply, assign(socket, :show_register_talk_modal, false)}
  end

  @impl true
  def handle_info(:close_register_talk_modal, socket) do
    socket =
      socket
      |> assign(:show_register_talk_modal, false)
      |> put_flash(:info, "Successfully registered for a talk! See you there! :-)")

    {:noreply, socket}
  end
end
