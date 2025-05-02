defmodule OtterWebsite.Repo.Migrations.CreateTalks do
  use Ecto.Migration

  def change do
    create table(:talks) do
      add :title, :string
      add :author, :string

      timestamps(type: :utc_datetime)
    end
  end
end
