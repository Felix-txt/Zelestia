defmodule ZelestiaWeb.AccountLogoutTest do
  use ZelestiaWeb.ConnCase, async: true

  setup %{conn: conn} do
    conn = post(conn, "/account/create", %{username: "Login", password: "password"})
    %{conn: conn}
  end

  describe "POST /account/logout" do
    test "Account logout succes", %{conn: conn} do
      assert get_session(conn, :user_id) != nil

      conn = post(conn, ~p"/account/logout")

      assert redirected_to(conn) == ~p"/account/login"

      assert get_session(conn, :user_id) == nil
    end
  end
end
