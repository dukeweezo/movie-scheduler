defmodule MovieScheduler.Accounts do
  @moduledoc """
  The Accounts context.

  Various construct_grids functions are used to change corresponding grids (e.g. empty grids) in database.
  Probablhy best in another module and / or using database triggers.  
  """

  import Ecto.Query, warn: false
  alias MovieScheduler.Repo

  alias MovieScheduler.Accounts.Schedule

  use Timex

  @doc """
  Returns the list of schedules.

  ## Examples

      iex> list_schedules()
      [%Schedule{}, ...]

  """
  def list_schedules do
    Repo.all(Schedule)
  end

  @doc """
  Returns the list of schedules.

  ## Examples

      iex> list_schedules()
      [%Schedule{}, ...]

  """

  def list_schedules_x_days_out(range \\ 4) do
    today = Timex.today()
    x_days_out = Timex.shift(Timex.today(), days: range)

    query = from s in Schedule,
          where: ^today <= s.the_date and s.the_date <= ^x_days_out,
          select: s

    Repo.all(query)
  end

  @doc """
  Gets a single schedule.

  Raises `Ecto.NoResultsError` if the Schedule does not exist.

  ## Examples

      iex> get_schedule!(123)
      %Schedule{}

      iex> get_schedule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_schedule!(id), do: Repo.get!(Schedule, id)

  @doc """
  Creates a schedule.

  ## Examples

      iex> create_schedule(%{field: value})
      {:ok, %Schedule{}}

      iex> create_schedule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schedule(%{"time" => time, "length" => length}) do
    attrs = %{:"#{time}" => %{"length" => length}}
    dbg attrs
    #%Schedule{}
    #|> Schedule.changeset(attrs)
    #|> dbg
    #|> Repo.insert()
  end

  @doc """
  Updates a schedule.

  ## Examples

      iex> update_schedule(schedule, %{field: new_value})
      {:ok, %Schedule{}}

      iex> update_schedule(schedule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  defp construct_grids(asset_length, time, prev_length, filled_grid) when asset_length == 1 do
    new_grids = 
      Enum.reduce(time+asset_length..time+prev_length-1, filled_grid, fn 
        x, acc ->
          Map.merge(acc, %{:"#{x}" => %{"length" => 1}})
      end)     

    {:ok, new_grids}
  end

  defp construct_grids(asset_length, time, prev_length, filled_grid) when asset_length < prev_length do
    new_grids =
      Enum.reduce(time+1..time+asset_length-1, filled_grid, fn 
        x, acc ->
          Map.merge(acc, %{:"#{x}" => %{}})
      end)

    new_grids = 
      Enum.reduce(time+asset_length..time+prev_length-1, new_grids, fn 
        x, acc ->
          Map.merge(acc, %{:"#{x}" => %{"length" => 1}})
      end)

    {:ok, new_grids}   
  end

  defp construct_grids(asset_length, time, prev_length, filled_grid) when asset_length > prev_length do
    new_grids = 
      Enum.reduce(time+1..time+asset_length-1, filled_grid, fn 
        x, acc ->
          Map.merge(acc, %{:"#{x}" => %{}})
      end)

    {:ok, new_grids}
  end

  defp construct_grids(asset_length, time, prev_length, filled_grid) do
    {:error, "Lengths are the same"}
  end

  def update_schedule(%Schedule{} = schedule, %{"id" => id, "length" => length, "time" => time, "asset_id" => asset_id}) do
    filled_grid = 
      %{:"#{time}" => %{"length" => length, "asset_id" => asset_id}}

    prev_length = Map.fetch!(schedule, :"#{time}")["length"]

    grids = construct_grids(length, time, prev_length, filled_grid)

    case grids do
      {:ok, grids} ->
        schedule
        |> Schedule.changeset(grids)
        |> Repo.update()
      
      {:error, error} ->
        schedule
        |> Schedule.changeset(%{})
        |> Repo.update()
    end
  end


  @doc """
  Deletes a schedule.

  ## Examples

      iex> delete_schedule(schedule)
      {:ok, %Schedule{}}

      iex> delete_schedule(schedule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_schedule(%Schedule{} = schedule) do
    Repo.delete(schedule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schedule changes.

  ## Examples

      iex> change_schedule(schedule)
      %Ecto.Changeset{data: %Schedule{}}

  """
  def change_schedule(%Schedule{} = schedule, attrs \\ %{}) do
    Schedule.changeset(schedule, attrs)
  end
end
