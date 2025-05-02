defmodule OtterWebsite.Meetups do
  @moduledoc """
  The Meetups context.
  """

  import Ecto.Query, warn: false
  alias OtterWebsite.Repo

  alias OtterWebsite.Meetups.Meetup

  @doc """
  Returns the list of meetups.

  ## Examples

      iex> list_meetups()
      [%Meetup{}, ...]

  """
  def list_meetups do
    Repo.all(Meetup)
  end

  def list_meetups_in_order do
    Repo.all(from m in Meetup, order_by: [asc: m.date])
  end

  def get_upcoming_meetup do
    now = NaiveDateTime.utc_now() # FIXME must be rewritten with timezone-awareness, but requires change in database from naive to something with timezone

    Repo.one(from m in Meetup, where: m.date > ^now, order_by: [asc: m.date], limit: 1)
  end

  @doc """
  Gets a single meetup.

  Raises `Ecto.NoResultsError` if the Meetup does not exist.

  ## Examples

      iex> get_meetup!(123)
      %Meetup{}

      iex> get_meetup!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meetup!(id), do: Repo.get!(Meetup, id)

  @doc """
  Creates a meetup.

  ## Examples

      iex> create_meetup(%{field: value})
      {:ok, %Meetup{}}

      iex> create_meetup(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meetup(attrs \\ %{}) do
    %Meetup{}
    |> Meetup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meetup.

  ## Examples

      iex> update_meetup(meetup, %{field: new_value})
      {:ok, %Meetup{}}

      iex> update_meetup(meetup, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meetup(%Meetup{} = meetup, attrs) do
    meetup
    |> Meetup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meetup.

  ## Examples

      iex> delete_meetup(meetup)
      {:ok, %Meetup{}}

      iex> delete_meetup(meetup)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meetup(%Meetup{} = meetup) do
    Repo.delete(meetup)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meetup changes.

  ## Examples

      iex> change_meetup(meetup)
      %Ecto.Changeset{data: %Meetup{}}

  """
  def change_meetup(%Meetup{} = meetup, attrs \\ %{}) do
    Meetup.changeset(meetup, attrs)
  end
end
