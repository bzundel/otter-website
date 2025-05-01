defmodule OtterWebsite.Repo.Migrations.AddUsedFieldToInvitationKey do
  use Ecto.Migration

  def change do
    alter table(:invitation_keys) do
      add :used, :boolean, default: false, null: false
    end
  end
end
