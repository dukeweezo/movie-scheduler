defmodule MovieSchedulerWeb.ScheduleController do
  use MovieSchedulerWeb, :controller

  alias MovieScheduler.Accounts
  alias MovieScheduler.Accounts.Schedule

  action_fallback MovieSchedulerWeb.FallbackController

  def index(conn = %{method: "GET"}, %{"action" => action, "value" => value}) do
    schedules =
      case action do
        "list_schedules_x_days_out" ->
          Accounts.list_schedules_x_days_out(String.to_integer(value))
        _ ->
          []
      end

    render(conn, :index, schedules: schedules)
  end

  def index(conn = %{method: "GET"}, _params) do
    schedules = Accounts.list_schedules()
    render(conn, :index, schedules: schedules)
  end

  def create(conn, params) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    
    with {:ok, %Schedule{} = schedule} <- Accounts.create_schedule(Poison.decode!(body)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api_v1/schedules/#{schedule}")
      |> render(:show, schedule: schedule)
    end
  end

  def show(conn, %{"id" => id}) do
    schedule = Accounts.get_schedule!(id)
    render(conn, :show, schedule: schedule)
  end

  def update(conn, params = %{"id" => id}) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)

    attrs = 
      Poison.decode!(body)
      |> Map.merge(params)

    schedule = Accounts.get_schedule!(id)

    with {:ok, %Schedule{} = schedule} <- Accounts.update_schedule(schedule, attrs) do
      render(conn, :show, schedule: schedule)
    end
  end

  def delete(conn, %{"id" => id}) do
    schedule = Accounts.get_schedule!(id)

    with {:ok, %Schedule{}} <- Accounts.delete_schedule(schedule) do
      send_resp(conn, :no_content, "")
    end
  end
end
