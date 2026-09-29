defmodule ZelestiaWeb.UserHandler do
  use GenServer

  @table_name :users

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
    Returns `user_id`.
  """
  def register_user(user_name, password) do
    user_id = Ecto.UUID.generate(version: 7)
    GenServer.cast(__MODULE__, {:register, user_id, user_name, password})
    user_id
  end

  def init(:ok) do
    state = :ets.new(@table_name, [:ordered_set, :protected, :named_table, read_concurrency: true])
    {:ok, state}
  end

  def handle_cast({:register, user_id, user_name, password}, state) do
    :ets.insert(@table_name, {user_id, user_name, password})
    {:noreply, state}
  end
end
