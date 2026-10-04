defmodule ZelestiaWeb.AccountCreationTest do
  use ZelestiaWeb.ConnCase

  describe "POST /account/create" do
    test "Create account succes", %{conn: conn} do
      conn = post(conn, ~p"/account/create", %{
        "username" => "Test", "password" => "password"
      })
      assert redirected_to(conn) == ~p"/"

      assert get_session(conn, :user_id) != nil
    end
  end

end
