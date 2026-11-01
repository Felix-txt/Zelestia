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


  defp create_request(_uid1, "", _status), do: %{ status: "error", message: "Is not a user"}
  defp create_request(uid1, uid2, _status) when uid1 == uid2, do: %{ status: "error", message: "Cant add your self"}
  defp create_request(_uid1, _uid2, "sent"), do: %{ status: "error", message: "Already pending"}
  defp create_request(_uid1, _uid2, "friends"), do: %{ status: "error", message: "You are already friends"}
  defp create_request(uid1, uid2, "pending") do
    # Auto accept pending request
    accept(uid1, uid2, "pending")
  end
  defp create_request(uid1, uid2, _status) do
    FriendsHandler.new_request(uid1, uid2)

    %{ status: "ok", message: "Friend request sent"}
  end


  def accept_request(conn, params) do
    uid1 = get_session(conn)["user_id"]
    uid2 = FriendsHandler.get_friend_id(params["username"])

    status = FriendsHandler.get_status(uid1, uid2)

    resp_data = create_request(uid1, uid2, status)

    json(conn, resp_data)
  end

  defp accept(uid1, uid2, "pending") do
    FriendsHandler.accept_request(uid1, uid2)
    %{ status: "ok", message: "Friend request accepted"}
  end
   defp accept(_, _, _), do: %{ status: "error", message: "No pending request"}


end
