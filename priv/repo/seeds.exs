alias OtterWebsite.Repo
alias OtterWebsite.Accounts.InvitationKey

unless Repo.exists?(InvitationKey) do
  Repo.insert!(%InvitationKey{key: "INITIAL_ADMIN_KEY"})
end
