defmodule OtterWebsite.Helpers.MastodonTooter do
  def toot_meetup(meetup) do
    base_url = Application.get_env(:hunter, :mastodon_base_url)
    access_token = Application.get_env(:hunter, :mastodon_access_token)

    conn = Hunter.new([base_url: base_url, bearer_token: access_token])
    message = create_message(meetup)

    if String.length(message) > 500 do # FIXME make dynamic based on instance max. length
      {:error, "Message too long"}
    else
      Hunter.create_status(conn, message)

      {:ok, "Published (probably :-))"}
    end
  end

  def create_message(meetup) do
    greeting = "Am #{Calendar.strftime(meetup.date, "%Y-%m-%d")} um #{Calendar.strftime(meetup.date, "%H:%M Uhr")} treffen wir uns wieder in Raum #{meetup.room}!"
    talks = "Folgende Talks sind angemeldet:\n" <> Enum.join(Enum.map(meetup.talks, fn talk -> "- #{talk.author}: \"#{talk.title}\"" end), "\n")
    ending = "Wir freuen uns euch dort zu sehen!"
    message_components = ["--- DEVELOPMENT TESTING ---", greeting, talks, ending] # FIXME remove for prod

    Enum.join(message_components, "\n\n")
  end
end
