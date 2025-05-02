defmodule OtterWebsite.Meetups.Talk do
  use Ecto.Schema
  import Ecto.Changeset

  schema "talks" do
    field :title, :string
    field :author, :string

    belongs_to :meetup, OtterWebsite.Meetups.Meetup

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, [:title, :author, :meetup_id])
    |> validate_required([:title, :author, :meetup_id])
    |> assoc_constraint(:meetup)
  end
end
