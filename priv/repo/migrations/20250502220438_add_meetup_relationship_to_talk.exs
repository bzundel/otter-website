defmodule OtterWebsite.Repo.Migrations.AddMeetupRelationshipToTalk do
  use Ecto.Migration

  def change do
    alter table(:talks) do
      add :meetup_id, references(:meetups, on_delete: :delete_all), null: false
    end

    create index(:talks, [:meetup_id])
  end
end
