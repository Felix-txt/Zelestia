defmodule ZelestiaWeb.Chat do
  use ZelestiaWeb, :live_view

  @topic "public"
  @event_new_message "new_message"


  def render(assigns) do
    ~H"""
    <LiveSvelte.svelte name="ChatRoom" props={%{messages: @messages}} style="height=100%"/>
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
    [{_id, name, _password}] = :ets.lookup(:users, user_id)
    format(tail, [%{id: id, name: name, body: body} | acc])
  end

  def handle_event("send_message", event, socket) do
    [{_id, name, _password}] = :ets.lookup(:users, socket.assigns.user_id)
    user_id = socket.assigns.user_id
    message_id = add_new_message(user_id, event["body"])
    event =
      event
      |> Map.put("name", name)
      |> Map.put("id", message_id)


    ZelestiaWeb.Endpoint.broadcast(@topic, @event_new_message, event)

    {:noreply, socket}

  end

  def handle_info(%{topic: @topic, event: @event_new_message, payload: payload}, socket) do
    #payload = Map.put(payload, :id, System.unique_integer([:positive]))

    {:noreply, assign(socket, messages: socket.assigns.messages ++ [payload])}
  end

end
