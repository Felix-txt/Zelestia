defmodule ZelestiaWeb.FriendsHandler do
  use GenServer

  @table_name :friends

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
    Returns `message_id`.
  """
  def new_request(user_id, friend_id) do
    GenServer.cast(__MODULE__, {:new_request, user_id, friend_id})
  end

  def get_status(u_id1, u_id2) do
    match_patern =
      [
        {
          {:"$1", :"$2", :"$3"},
          [{:==, :"$1", u_id1, },
          {:==, :"$2", u_id2, }],
          [:"$3"]
        }
      ]

      result = :ets.select(@table_name, match_patern);

      case result do
        [status] -> status
        [] -> nil
      end
  end

  def get_friend_id(user_name) do
    match_patern =
      [
        {
          {:"$1", :"$2", :"$3"},
          [{:==, :"$2", user_name}],
          [:"$1"]
        }
      ]

    result = :ets.select(:users, match_patern)

    case result do
      [] -> ""
      [uid] -> uid
    end
  end


  def remove_friend(user_id, friend_id) do
    GenServer.cast(__MODULE__, {:remove_friend, user_id, friend_id, })
  end

  def init(:ok) do
    state = :ets.new(@table_name, [:ordered_set, :protected, :named_table, read_concurrency: true])
    {:ok, state}
  end

  def handle_cast({:new_request, u_id1, u_id2}, state) do
    :ets.insert(@table_name, {u_id1, u_id2, "sent"})
    :ets.insert(@table_name, {u_id2, u_id1, "pending"})
    {:noreply, state}
  end

  def handle_cast({:remove_friend, u_id1, u_id2, status}, state) do
    :ets.delete_object(@table_name, {u_id1, u_id2, status})
    :ets.delete_object(@table_name, {u_id2, u_id1, status})
    {:noreply, state}
  end

end
