defmodule OtterWebsite.Meetups.Meetup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetups" do
    field :date, :naive_datetime
    field :room, :string

    has_many :talks, OtterWebsite.Meetups.Talk

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meetup, attrs) do
    meetup
    |> cast(attrs, [:date, :room])
    |> validate_required([:date, :room])
  end
end
