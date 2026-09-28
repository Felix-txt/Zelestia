defmodule ZelestiaWeb.Chat do
  use ZelestiaWeb, :live_view

  @topic "public"
  @event_new_message "new_message"


  def render(assigns) do
    ~H"""
    <LiveSvelte.svelte name="ChatRoom" props={%{messages: @messages}} />
    """
  end

  def mount(_params, session, socket) do
    ZelestiaWeb.Endpoint.subscribe(@topic)

    messages =
      :ets.tab2list(:messages)
      |> format([])

    {:ok, assign(socket, messages: messages, user_id: session["user_id"])}
  end

  defp format([], acc), do: Enum.reverse(acc)
  defp format([head | tail], acc) do
    {id, user_id, body} = head
    [{_id, name, _password}] = :ets.match_object(:users, {user_id, :_ , :_})
    format(tail, [%{id: id, name: name, body: body} | acc])
  end

  def handle_event("send_message", event, socket) do
    [{_id, name, _password}] = :ets.match_object(:users, {socket.assigns.user_id, :_ , :_})
    size = :ets.info(:messages, :size)
    event =
      event
      |> Map.put("id", size + 1)
      |> Map.put("name", name)

    :ets.insert(:messages, {event["id"] , socket.assigns.user_id, event["body"]})
    ZelestiaWeb.Endpoint.broadcast(@topic, @event_new_message, event)
    {:noreply, socket}

  end

  def handle_info(%{topic: @topic, event: @event_new_message, payload: payload}, socket) do
    #payload = Map.put(payload, :id, System.unique_integer([:positive]))
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [payload])}
  end

end
