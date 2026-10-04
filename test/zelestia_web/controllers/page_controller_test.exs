defmodule ZelestiaWeb.PageControllerTest do
  use ZelestiaWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 302)
    assert redirected_to(conn) == ~p"/account/login"
  end
end
