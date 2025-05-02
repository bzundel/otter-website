defmodule OtterWebsiteWeb.Home.Dialogs.RegisterTalkDialog do
  use OtterWebsiteWeb, :live_component

  alias OtterWebsite.Meetups
  alias OtterWebsite.Meetups.Talk

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <span class="text-md font-bold">{@title}</span>

      <.form for={@form} phx-submit="save" phx-change="validate" phx-target={@myself}>
        <div class="flex flex-col gap-y-4 mt-2">
          <.input label="Title" type="text" field={@form[:title]}/>
          <.input label="Display name" type="text" field={@form[:author]}/>
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
      |> assign(:page_title, "Register for a talk")
      |> assign(:form, to_form(Meetups.change_talk(%Talk{})))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"talk" => talk_params}, socket) do
    changeset =
      %Talk{}
      |> Meetups.change_talk(talk_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"talk" => talk_params}, socket) do
    talk_params = Map.put(talk_params, "meetup_id", socket.assigns.meetup_id)

    case Meetups.create_talk(talk_params) do
      {:ok, _talk} ->
        send(self(), :close_register_talk_modal)
        {:noreply,
         socket
         |> assign(:form, to_form(Meetups.change_talk(%Talk{})))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
