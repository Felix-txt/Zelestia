defmodule ZelestiaWeb.AccountLoginTest do
  use ZelestiaWeb.ConnCase, async: true

  alias ZelestiaWeb.UserHandler

  UserHandler.register_user("Testss", Bcrypt.hash_pwd_salt("password"))

  describe "POST /account/login" do
    test "Account loggin fail username", %{conn: conn} do


      conn = post(conn, ~p"/account/login", %{
        "username" => "Testa", "password" => "password"
      })

      assert redirected_to(conn) == ~p"/account/login"

      assert get_session(conn, :user_id) == nil
    end

    test "Account loggin fail password", %{conn: conn} do

      conn = post(conn, ~p"/account/login", %{
        "username" => "Testss", "password" => "passwsord"
      })

      assert redirected_to(conn) == ~p"/account/login"

      assert get_session(conn, :user_id) == nil
    end

    test "Account loggin fail both", %{conn: conn} do

      conn = post(conn, ~p"/account/login", %{
        "username" => "Testsas", "password" => "passwsord"
      })

      assert redirected_to(conn) == ~p"/account/login"

      assert get_session(conn, :user_id) == nil
    end

    test "Account loggin succes", %{conn: conn} do

      conn = post(conn, ~p"/account/login", %{
        "username" => "Testss", "password" => "password"
      })

      assert redirected_to(conn) == ~p"/"

      assert get_session(conn, :user_id) != nil
    end
  end

end
