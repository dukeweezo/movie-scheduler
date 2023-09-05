defmodule MovieScheduler.Assets do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias MovieScheduler.Repo

  alias MovieScheduler.Assets.Movie


  @doc """
  Returns the list of movies.

  ## Examples

      iex> list_movies()
      [%Movie{}, ...]

  """
  def list_movies do
    Repo.all(Movie)
  end

  @doc """
  Gets a single Movie.

  Raises `Ecto.NoResultsError` if the Movie does not exist.

  ## Examples

      iex> get_movie!(123)
      %Movie{}

      iex> get_movie!(456)
      ** (Ecto.NoResultsError)

  """
  def get_movie!(id), do: Repo.get!(Movie, id)

  @doc """
  Creates a Movie.

  ## Examples

      iex> create_movie(%{field: value})
      {:ok, %Movie{}}

      iex> create_movie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movie(attrs) do
    #...
  end

  @doc """
  Updates a Movie.

  ## Examples

      iex> update_movie(Movie, %{field: new_value})
      {:ok, %Movie{}}

      iex> update_movie(Movie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_movie(%Movie{} = Movie, attrs \\ %{}) do
    # ...
  end

  @doc """
  Deletes a Movie.

  ## Examples

      iex> delete_movie(Movie)
      {:ok, %Movie{}}

      iex> delete_movie(Movie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movie(%Movie{} = Movie) do
    Repo.delete(Movie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Movie changes.

  ## Examples

      iex> change_movie(Movie)
      %Ecto.Changeset{data: %Movie{}}

  """
  def change_movie(%Movie{} = Movie, attrs \\ %{}) do
    Movie.changeset(Movie, attrs)
  end
end
