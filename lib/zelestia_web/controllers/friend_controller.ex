defmodule ZelestiaWeb.FriendController do
  alias ZelestiaWeb.FriendsHandler
  use ZelestiaWeb, :controller

  def new_request(conn, params) do

    uid1 = get_session(conn)["user_id"]
    uid2 = FriendsHandler.get_friend_id(params["username"])

    status = FriendsHandler.get_status(uid1, uid2)

    resp_data = create_request(uid1, uid2, status)

    json(conn, resp_data)
  end


  def create_request(_uid1, "", _status), do: %{ status: "error", message: "Is not a user"}
  def create_request(uid1, uid2, _status) when uid1 == uid2, do: %{ status: "error", message: "Cant add your self"}
  def create_request(_uid1, _uid2, status) when status == "sent", do: %{ status: "error", message: "Already pending"}
  def create_request(_uid1, _uid2, status) when status == "friends", do: %{ status: "error", message: "You are already friends"}
  def create_request(_uid1, _uid2, status) when status == "pending" do
    # Change to ok and accept request when user has pending friend request from target user
   %{ status: "error", message: "Already pending"}
  end
  def create_request(uid1, uid2, _status) do
    FriendsHandler.new_request(uid1, uid2)

    %{ status: "ok", message: "Friend request sent"}
  end


  def accept_request(conn, _params) do
    conn
  end

end
