defmodule OtterWebsite.Repo.Migrations.CreateInvitationKeys do
  use Ecto.Migration

  def change do
    create table(:invitation_keys) do
      add :key, :string

      timestamps(type: :utc_datetime)
    end
  end
end
