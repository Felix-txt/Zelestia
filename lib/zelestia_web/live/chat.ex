defmodule ZelestiaWeb.Chat do
  use ZelestiaWeb, :live_view

  @event_new_message "new_message"

  def render(assigns) do
    ~H"""
    <LiveSvelte.svelte name="ChatRoom" props={%{messages: @messages}} style="height=100%"/>
    """
  end

  def mount(params, session, socket) do
    channel_id = params["channel_id"]
    IO.inspect(channel_id)

    ZelestiaWeb.Endpoint.subscribe(channel_id)

    match_patern =
      [
        {
          {:"$1", :"$2", :"$3", :"$4"},
          [{:==, :"$2", channel_id}],
          [:"$_"]
        }
      ]

    messages =
      :ets.select_reverse(:messages, match_patern)
      |> format([])


    {:ok, assign(socket, messages: messages, channel_id: channel_id, user_id: session["user_id"])}
  end

  defp format([], acc), do: acc
  defp format([head | tail], acc) do
    {id, _channel_id, user_id, body} = head
    [{_id, name, _password}] = :ets.lookup(:users, user_id)
    format(tail, [%{id: id, name: name, body: body} | acc])
  end

  def handle_event("send_message", event, socket) do
    [{_id, name, _password}] = :ets.lookup(:users, socket.assigns.user_id)
    channel_id = socket.assigns.channel_id
    user_id = socket.assigns.user_id

    message_body = MDEx.to_html!(event["body"])

    message_id = add_new_message(channel_id, user_id, message_body)

    event =
      event
      |> Map.put("name", name)
      |> Map.put("id", message_id)
      |> Map.put("body", message_body)

    ZelestiaWeb.Endpoint.broadcast(channel_id, @event_new_message, event)

    {:noreply, socket}
  end


  def handle_info(%{topic: _topic, event: @event_new_message, payload: payload}, socket) do
    #payload = Map.put(payload, :id, System.unique_integer([:positive]))
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [payload])}
  end

end
