defmodule MovieSchedulerWeb.ScheduleJSON do
  alias MovieScheduler.Accounts.Schedule

  defp default_hour_fields(schedule) do
    Enum.reduce(1..48, %{}, fn 
      n, acc ->
        Map.merge(acc, %{"#{n}" => Map.fetch!(schedule, :"#{n}")})
    end)
  end

  @doc """
  Renders a list of schedules.
  """
  def index(%{schedules: schedules}) do
    %{data: for(schedule <- schedules, do: data(schedule))}
  end

  @doc """
  Renders a single schedule.
  """
  def show(%{schedule: schedule}) do
    %{data: data(schedule)}
  end

  defp data(%Schedule{} = schedule) do
    %{
      id: schedule.id,
      the_date: schedule.the_date,
    } |> Map.merge(default_hour_fields(schedule))
  end
end
