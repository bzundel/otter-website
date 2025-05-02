defmodule OtterWebsite.Repo.Migrations.CreateMeetups do
  use Ecto.Migration

  def change do
    create table(:meetups) do
      add :date, :naive_datetime
      add :room, :string

      timestamps(type: :utc_datetime)
    end
  end
end
