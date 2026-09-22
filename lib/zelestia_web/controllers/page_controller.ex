defmodule ZelestiaWeb.PageController do
  use ZelestiaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
