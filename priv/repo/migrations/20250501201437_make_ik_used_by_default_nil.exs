defmodule OtterWebsite.Repo.Migrations.MakeIkUsedByDefaultNil do
  use Ecto.Migration

  def change do
    alter table(:invitation_keys) do
      modify :used_by, :string, default: nil, null: true
    end
  end
end
