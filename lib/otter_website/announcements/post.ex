defmodule OtterWebsite.Announcements.Post do
  @enforce_keys [:title, :description, :author, :body, :tags]
  defstruct [:title, :description, :author, :body, :tags]

  def build(_filename, attrs, body) do
    struct!(__MODULE__, [body: body] ++ Map.to_list(attrs))
  end
end
