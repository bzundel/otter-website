defmodule OtterWebsiteWeb.Admin.Dialogs.CreateMeetupDialog do
alias OtterWebsite.Meetups.Meetup
alias OtterWebsite.Meetups
  use OtterWebsiteWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <span class="text-md font-bold">{@title}</span>

    <.form for={@form} phx-submit="save" phx-change="validate" phx-target={@myself}>
      <div class="flex flex-col gap-y-4 mt-2">
        <.input label="Date and time" type="datetime-local" field={@form[:date]}/>
        <.input label="Room" type="text" field={@form[:room]}/>
      </div>

      <div class="flex justify-end">
        <.button class="mt-4">Submit</.button>
      </div>
    </.form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:page_title, "Create meetup")
      |> assign(:form, to_form(Meetups.change_meetup(%Meetup{})))
    {:ok, assign(socket, :page_title, "Create meetup")}
  end

  @impl true
  def handle_event("validate", %{"meetup" => meetup_params}, socket) do
    changeset =
      %Meetup{}
      |> Meetups.change_meetup(meetup_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"meetup" => meetup_params}, socket) do
    case Meetups.create_meetup(meetup_params) do
      {:ok, _meetup} ->
        send(self(), :close_create_meetup_modal)
        {:noreply,
         socket
         |> assign(:form, to_form(Meetups.change_meetup(%Meetup{})))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
