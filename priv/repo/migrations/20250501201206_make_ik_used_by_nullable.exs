defmodule OtterWebsite.Repo.Migrations.MakeIkUsedByNullable do
  use Ecto.Migration

  def change do
    alter table(:invitation_keys) do
      modify :used_by, :string, null: true
    end
  end
end
