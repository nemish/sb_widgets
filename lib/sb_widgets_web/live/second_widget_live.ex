defmodule SbWidgetsWeb.SecondWidgetLive do
  use SbWidgetsWeb, :live_view

  def mount(params, _session, socket) do
    connect_params = get_connect_params(socket)

    socket =
      socket
      |> assign(:count, 0)
      |> assign_name(params, connect_params)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div data-app={"app-#{@widget_name}"}>
      <meta name={"csrf-token-#{@widget_name}"} content={Plug.CSRFProtection.get_csrf_token()} />
      <%!-- <link phx-track-static rel="stylesheet" href="http://localhost:4000/assets/app.css" /> --%>
      <div class="text-2xl font-bold">Second widget</div>
      <div>Counter: <%= @count %></div>
      <button phx-click="decrement">Decrement</button>
    </div>
    """
  end

  defp assign_name(socket, %{"name" => name}, _connect_params) do
    socket |> assign(:widget_name, name)
  end

  defp assign_name(socket, _params, %{"widget_name" => name}) do
    socket |> assign(:widget_name, name)
  end

  defp assign_name(socket, _params, _connect_params) do
    socket |> assign(:widget_name, nil)
  end

  def handle_event("decrement", _unsigned_params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count - 1)}
  end
end
