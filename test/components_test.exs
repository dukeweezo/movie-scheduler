defmodule MovieSchedulerWeb.ComponentsTest do
  use MovieSchedulerWeb.ConnCase
  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  
  test "main scheduler", %{conn: conn} do
    #html = view |> element("#user-13 a", "Delete") |> render_click()
    #refute html =~ "user-13"
    #refute view |> element("#user-13") |> has_element?()

    {:ok, view, html} = live(conn, "/")
    assert html =~ ~S(id="scheduler-main" class="contents")
  end

  test "asset picker", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
  end

end
