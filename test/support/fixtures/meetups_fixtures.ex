defmodule OtterWebsite.MeetupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OtterWebsite.Meetups` context.
  """

  @doc """
  Generate a meetup.
  """
  def meetup_fixture(attrs \\ %{}) do
    {:ok, meetup} =
      attrs
      |> Enum.into(%{
        date: ~N[2025-05-01 12:09:00],
        room: "some room"
      })
      |> OtterWebsite.Meetups.create_meetup()

    meetup
  end
end
