defmodule GameWeb.RoomsChannel do
  use GameWeb, :channel

  @impl true
  def join("rooms:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("rooms:" <> _room_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("new_message", payload, socket) do
    broadcast(socket, "shout", payload)
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("room_started", payload, socket) do
    IO.puts "oi"
    IO.inspect payload
    {:reply, {:ok, payload}, socket}
  end

  # @impl true
  # def handle_in("rooms:create", payload, socket) do
  #   %{
  #     name: payload["room_name"],
  #     players: [%{ name: payload["host_player"]["name"] }]
  #   } |> RoomRepository.create_room

  #   {:noreply, socket}
  # end

  # @impl true
  # def handle_in("rooms:feed", payload, socket) do
  #   IO.puts "handle in"
  #   {:reply, {:ok, payload}, socket}
  # end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
