defmodule OtterWebsite.Repo.Migrations.ChangeInvitationKeyFieldToUsedBy do
  use Ecto.Migration

  def change do
    rename table(:invitation_keys), :used, to: :used_by
    alter table(:invitation_keys) do
      modify :used_by, :string, from: :boolean
    end
  end
end
