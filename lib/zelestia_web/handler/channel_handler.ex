defmodule ZelestiaWeb.ChannelHandler do
  use GenServer

  @table_name :channels

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
    Returns `channel_id`.
  """
  def new_channel(type) do
    channel_id = Ecto.UUID.generate()
    GenServer.cast(__MODULE__, {:new_channel, channel_id, type})
    channel_id
  end
  @doc """
    Returns `channel_id`.
  """
  def new_channel(type, channel_id) do
    GenServer.cast(__MODULE__, {:new_channel, channel_id, type})
    channel_id
  end

  def init(:ok) do
    state = :ets.new(@table_name, [:ordered_set, :protected, :named_table, read_concurrency: true])
    {:ok, state}
  end

  def handle_cast({:new_channel, channel_id, type}, state) do
    :ets.insert(@table_name, {channel_id, type})
    {:noreply, state}
  end

end
