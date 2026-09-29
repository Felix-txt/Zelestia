defmodule ZelestiaWeb.MessageHandler do
  use GenServer

  @table_name :messages

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
    Returns `message_id`.
  """
  def add_new_message(user_id, message_body) do
    message_id = Ecto.UUID.generate(version: 7)
    GenServer.cast(__MODULE__, {:new_message, message_id, user_id, message_body})
    message_id
  end

  def init(:ok) do
    state = :ets.new(@table_name, [:ordered_set, :protected, :named_table, read_concurrency: true])
    {:ok, state}
  end

  def handle_cast({:new_message, message_id, user_id, message_body}, state) do

    :ets.insert(@table_name, {message_id, user_id, message_body})
    {:noreply, state}
  end

end
