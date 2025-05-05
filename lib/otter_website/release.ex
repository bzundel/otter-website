defmodule OtterWebsite.Release do
  alias OtterWebsite.Repo
  alias OtterWebsite.Accounts.InvitationKey

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    Application.ensure_all_started(:otter_website)
    unless Repo.exists?(InvitationKey) do
      Repo.insert!(%InvitationKey{key: "INITIAL_ADMIN_KEY"})
    end
  end

  defp repos do
    Application.load(:otter_website)
    Application.fetch_env!(:otter_website, :ecto_repos)
  end
end
