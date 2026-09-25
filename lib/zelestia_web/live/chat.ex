defmodule ZelestiaWeb.Chat do
  use ZelestiaWeb, :live_view

  @topic "public"
  @event_new_message "new_message"


  def render(assigns) do
    ~H"""
    <LiveSvelte.svelte name="ChatRoom" props={%{messages: @messages}} />
    """
  end

  def mount(_params, _session, socket) do
    ZelestiaWeb.Endpoint.subscribe(@topic)

    messages =
      :ets.tab2list(:messages)
      |> format([])

    {:ok, assign(socket, messages: messages)}
  end

  defp format([], acc), do: Enum.reverse(acc)
  defp format([head | tail], acc) do
    {id, name, body} = head
    format(tail, [%{id: id, name: name, body: body} | acc])
  end

  def handle_event("send_message", event, socket) do
    size = :ets.info(:messages, :size)
    event = Map.put(event, "id", size + 1)
    :ets.insert(:messages, {event["id"] ,event["name"], event["body"]})
    ZelestiaWeb.Endpoint.broadcast(@topic, @event_new_message, event)
    {:noreply, socket}
  end

  def handle_info(%{topic: @topic, event: @event_new_message, payload: payload}, socket) do
    #payload = Map.put(payload, :id, System.unique_integer([:positive]))
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [payload])}
  end

end
