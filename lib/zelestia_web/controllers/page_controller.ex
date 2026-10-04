defmodule ZelestiaWeb.PageController do
  use ZelestiaWeb, :controller
  alias ZelestiaWeb.ChannelHandler

  def home(conn, _params) do
    if (:ets.tab2list(:channels) == []) do
        ChannelHandler.new_channel("public", "public1")
        ChannelHandler.new_channel("public", "public2")
        ChannelHandler.new_channel("public", "public3")
    end

    channels = :ets.tab2list(:channels)


    render(conn, :home, channels: channels)
  end
end
