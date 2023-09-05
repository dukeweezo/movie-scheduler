defmodule MovieSchedulerWeb.Components.MainSchedule do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <div id="scheduler-main" class="contents">
        <%= for %{grid_id: grid_id, x: x, y: y, asset: asset,
                 length: length, schedule_id: schedule_id, 
                 asset_id: asset_id, relative_row_id: relative_row_id} <- @grids do %>

          <div 
            data-gridid={grid_id} 
            data-x={x} data-y={y} 
            data-scheduleid={schedule_id} 
            data-assetid={asset_id} 
            data-relativerowid={relative_row_id} 
            style={"grid-row: span #{length}"} 
            class={"#{if asset, do: "bg-asset border border-yellow-700"}
                    grid-item-subtle col-start-#{x} row-start-#{y+1} row-span-#{length}"}
          >
            <%= if asset do %>
              <div class="relative w-100 p-0 m-0">
                <div 
                  phx-value-scheduleid={schedule_id} 
                  phx-value-relativerowid={relative_row_id} 
                  phx-click="remove_scheduled_program" 
                  class={"#{if asset, do: "text-yellow-700"}
                          absolute top-1 right-2"}
                >
                  x
                </div>
              </div>
              <div class="p-2 text-xs w-20 text-yellow-500">
                <%= asset["title"] %>
              </div>
              
              <div class="p-2 text-xs w-20 text-yellow-500 underline">
                <a target="_blank" href={"/movies/#{asset_id}"}>Details</a>
              </div>
             
            <% end %>
          </div>
        <% end %>
      </div>
    """
  end
end