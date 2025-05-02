defmodule OtterWebsite.MeetupsTest do
  use OtterWebsite.DataCase

  alias OtterWebsite.Meetups

  describe "meetups" do
    alias OtterWebsite.Meetups.Meetup

    import OtterWebsite.MeetupsFixtures

    @invalid_attrs %{date: nil, room: nil}

    test "list_meetups/0 returns all meetups" do
      meetup = meetup_fixture()
      assert Meetups.list_meetups() == [meetup]
    end

    test "get_meetup!/1 returns the meetup with given id" do
      meetup = meetup_fixture()
      assert Meetups.get_meetup!(meetup.id) == meetup
    end

    test "create_meetup/1 with valid data creates a meetup" do
      valid_attrs = %{date: ~N[2025-05-01 12:09:00], room: "some room"}

      assert {:ok, %Meetup{} = meetup} = Meetups.create_meetup(valid_attrs)
      assert meetup.date == ~N[2025-05-01 12:09:00]
      assert meetup.room == "some room"
    end

    test "create_meetup/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meetups.create_meetup(@invalid_attrs)
    end

    test "update_meetup/2 with valid data updates the meetup" do
      meetup = meetup_fixture()
      update_attrs = %{date: ~N[2025-05-02 12:09:00], room: "some updated room"}

      assert {:ok, %Meetup{} = meetup} = Meetups.update_meetup(meetup, update_attrs)
      assert meetup.date == ~N[2025-05-02 12:09:00]
      assert meetup.room == "some updated room"
    end

    test "update_meetup/2 with invalid data returns error changeset" do
      meetup = meetup_fixture()
      assert {:error, %Ecto.Changeset{}} = Meetups.update_meetup(meetup, @invalid_attrs)
      assert meetup == Meetups.get_meetup!(meetup.id)
    end

    test "delete_meetup/1 deletes the meetup" do
      meetup = meetup_fixture()
      assert {:ok, %Meetup{}} = Meetups.delete_meetup(meetup)
      assert_raise Ecto.NoResultsError, fn -> Meetups.get_meetup!(meetup.id) end
    end

    test "change_meetup/1 returns a meetup changeset" do
      meetup = meetup_fixture()
      assert %Ecto.Changeset{} = Meetups.change_meetup(meetup)
    end
  end
end
