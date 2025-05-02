defmodule OtterWebsiteWeb.Live.AdminLive do
  use OtterWebsiteWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-8 items-center my-4">
      <span class="text-xl font-bold">Admin Board</span>

      <div>
        <span class="text-md font-bold">Appointments</span>
      </div>

      <div>
        <span class="text-md font-bold">Invitation keys</span>
        <.button>Generate key</.button>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
