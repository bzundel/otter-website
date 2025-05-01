defmodule OtterWebsite.Accounts.InvitationKey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitation_keys" do
    field :key, :string
    field :used_by, :string, default: nil

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invitation_key, attrs) do
    invitation_key
    |> cast(attrs, [:key])
    |> validate_required([:key])
  end
end
