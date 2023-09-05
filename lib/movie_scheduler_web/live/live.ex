defmodule MovieSchedulerWeb.Live do
  @moduledoc """
  Movie (asset) scheduling, allowing grabbing / placing of assets on specific days / 30 min segments.

  Has two components MainSchedule and AssetPicker (left 30-min and top day sections could be turned
  into components).
  """
  @moduledoc since: "1.0.0"

  use MovieSchedulerWeb, :live_view
  use Timex
  import MovieSchedulerWeb.Utilities
  import MovieSchedulerWeb.APICalls
  alias MovieSchedulerWeb.Components.MainSchedule 
  alias MovieSchedulerWeb.Components.AssetPicker

  def render(assigns) do
    ~H"""
      <div id="movie-scheduler" phx-hook="MovieScheduler">
        <div class="grid grid-cols-1 grid-rows-49 gap-0 w-1/12 float-left bg-day-to-night">
          <div class="sticky top-0 grid-item col-start-1 row-start-1 bg-[#0f0f0f]">&nbsp;</div>
          <div :for={{time, i} <- Enum.with_index(@time_range)} class={"grid-item col-start-1 row-start-#{i+2} text-[#6e6e6e]"}>
            <%= time %>
          </div>
        </div>

        <div class="grid grid-rows-49 grid-flow-col-dense bg-[#0f0f0f]">
          <div class="contents">
            <div :for={{{shorthand_name, formatted_date}, i} <- Enum.with_index(@dates)} class={"sticky top-0 grid-item col-start-#{i+1} row-start-1 bg-[#0f0f0f] text-[#6e6e6e] z-50"}>
              <%= shorthand_name %>
              <%= formatted_date %>
            </div>
          </div>

          <.live_component id="main" module={MainSchedule} grids={@grids} />

          <.live_component id="asset-picker" module={AssetPicker} assets={@assets} />

        </div>
      </div>
    """
  end

  # For 'x' action with Main. Changes grid with asset to empty grids in db via update_schedule/2.
  def handle_event("remove_scheduled_program", params, socket) do
    %{"relativerowid" => relative_row_id, 
      "scheduleid" => schedule_id} = params

    relative_row_id = String.to_integer(relative_row_id)
    schedule_id = String.to_integer(schedule_id)

    update_schedule(schedule_id, %{"time" => relative_row_id, "length" => 1, "asset_id" => nil})

    grids = get_grids()

    {:noreply, 
      socket
      |> assign(:grids, grids)
    }
  end

  # Grab action with AssetPicker. Interface with JS, passing values, via "phx:grab_asset".
  # app.js then allows next action "js:place-asset".
  def handle_event("grab_asset", params, socket) do
    %{
      "assetid" => asset_id, 
      "length" => length
    } = params

    {:noreply, push_event(socket, "phx:grab_asset", %{asset_id: asset_id, length: length})}
  end

  # Place asset action with MainScheduler, following "phx:grab_asset". Sent by app.js.
  def handle_event("js:place_asset", params, socket) do
    %{
      "grid_id" => target_id,
      "length" => length,
      "schedule_id" => schedule_id,
      "asset_id" => asset_id,
      "x" => x,
      "y" => y,
      "relative_row_id" => relative_row_id
    } = params

    length = String.to_integer(length)
    target_id = String.to_integer(target_id)
    schedule_id = String.to_integer(schedule_id)
    relative_row_id = String.to_integer(relative_row_id)

    update_schedule(schedule_id, %{"time" => relative_row_id, "length" => length, "asset_id" => asset_id})

    grids = get_grids()

    {:noreply, 
      socket
      |> assign(:grids, grids)
    }
  end

  # + - action with AssetPicker. Gets assets via API call and makes next / previous slice.
  # Slicing could / should be done via API call and DB query.
  def handle_event("get_assets", %{"usage" => "forward"}, socket = %{assigns: %{asset_indices: {i1, i2}}}) do
    assets = get_movies()
   
    {assets, i1, i2} =
      if (i2 + 5) < (length(assets) - 1) do
        {Enum.slice(assets, i1+5..i2+5), i1+5, i2+5}    
      else
        {Enum.slice(assets, i1..i2), i1, i2}  
      end

    {:noreply, 
      socket
      |> assign(:asset_indices, {i1, i2})
      |> assign(:assets, assets)
    }
  end

  # + - action with AssetPicker.
  def handle_event("get_assets", %{"usage" => "back"}, socket = %{assigns: %{asset_indices: {i1, i2}}}) when i1 == 0 and i2 == 4 do
    {:noreply, socket}
  end

  # + - action with AssetPicker.
  def handle_event("get_assets", %{"usage" => "back"}, socket = %{assigns: %{asset_indices: {i1, i2}}}) when i1 > 0 and i2 > 4 do
    assets = Enum.slice(get_movies(), i1-5..i2-5)

    {:noreply, 
      socket
      |> assign(:asset_indices, {i1-5, i2-5})
      |> assign(:assets, assets)
    }
  end

  # API callback for mount API calls.
  def handle_info({:api_call_done, {assets, grids}}, socket) do
    {:noreply, 
      socket
      |> assign(:assets, assets)
      |> assign(:grids, grids)
    }
  end

  # These are generated compile-time.
  @default_time_range generate_24_hr_clock_time()
  @default_dates generate_dates()
 
  def mount(_params, session, socket) do
    # Check to make async API calls after connecting.
    if connected?(socket) do
      view_pid = self()

      # Spawn separate processes to handle async API calls.
      spawn(fn -> 
        assets = Enum.slice(get_movies(), 0..4)
        grids = get_grids() 

        send(view_pid, {:api_call_done, {assets, grids}})
      end)
    end

    # Default values before connection. 
    {:ok,
      socket
      |> assign(:time_range, @default_time_range)
      |> assign(:dates, @default_dates)
      |> assign(:grids, %{})
      |> assign(:assets, %{})
      |> assign(:asset_indices, {0, 4})
      #|> assign(:after_first?, true) # Could be used with mount default params to do 
                                      # a first-time 'seeding' of data, 
                                      # i.e. no API call every re-render.
    }
  end

end