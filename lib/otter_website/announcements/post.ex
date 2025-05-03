defmodule OtterWebsite.Announcements.Post do
  @enforce_keys [:identifier, :title, :description, :author, :datetime, :body, :tags]
  defstruct [:identifier, :title, :description, :author, :datetime, :body, :tags]

  def build(filename, attrs, body) do
    [year, month, day, hour, minute, identifier] = filename |> Path.basename(".md") |> String.split("_", parts: 6) # FIXME i'm very tired and cannot think elixir right now. rewrite this trash
    [year, month, day, hour, minute] = Enum.map([year, month, day, hour, minute], &String.to_integer/1)
    datetime = NaiveDateTime.new!(year, month, day, hour, minute, 0)
    struct!(__MODULE__, [identifier: identifier, datetime: datetime, body: body] ++ Map.to_list(attrs))
  end
end
