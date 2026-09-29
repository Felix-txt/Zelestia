defmodule ZelestiaWeb.AccountController do
  use ZelestiaWeb, :controller

  def load_login(conn, _options) do
    render(conn, :login)
  end

  def load_create(conn, _options) do
    render(conn, :create)
  end

  def create(conn, params) do
    encrypted_password = Bcrypt.hash_pwd_salt(params["password"])

    user_id = Ecto.UUID.generate(version: 7)

    :ets.insert(:users, {user_id, params["username"], encrypted_password})

    put_session(conn, :user_id, user_id)
    |> redirect(to: ~p"/")
  end

  def logout(conn, _params) do
    configure_session(conn, drop: true)
    |> redirect(to: ~p"/account/login")
  end

  def login(conn, params) do
    username = params["username"]
    # missing field -> empty string, so verify_pass gets a binary and simply returns false
    password = params["password"] || ""

    match_pattern = {:_, username, :_}

    result = :ets.match_object(:users, match_pattern)

    case length(result) do

      0 ->
        # run a dummy hash so this branch takes as long as a real check
        # (otherwise response time reveals which usernames exist)
        Bcrypt.no_user_verify()
        redirect(conn, to: ~p"/account/login")

      # user with that username exists
      _ ->
        [{id, _, password_hash}] = result

        # make sure password is correct
        if Bcrypt.verify_pass(password, password_hash) do
          put_session(conn, :user_id, id)
          |> redirect(to: ~p"/")
        else
          redirect(conn, to: ~p"/account/login")
        end
    end


  end

end
