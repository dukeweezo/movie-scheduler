defmodule MovieSchedulerWeb.Components.AssetPicker do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
      <div class="contents">
        <div class="grid h-screen col-start-6 row-start-1 row-span-full sticky top-0 bg-asset text-[#7a7a7a]">
          <div class="w-100">
            <div class="flex justify-around m-auto">
              <div phx-click={JS.push("get_assets", value: %{usage: :back})}>-</div>
              <div phx-click={JS.push("get_assets", value: %{usage: :forward})}>+</div>
            </div>
          </div>

          <%= for asset <- @assets do %>
            <div
              class={"grid-item"}
              phx-click={JS.push("grab_asset")}
              phx-value-assetid={asset["id"]} 
              phx-value-length={asset["duration"]}
            >
              <div class="p-2 text-xs w-20">
                <%= asset["title"] %>
              </div>

              <div class="p-2 text-xs w-20">
                ~<%= asset["formatted_length"] %> hrs
              </div>

            </div>
          <% end %>
        </div>
      </div>
    """
  end
end

