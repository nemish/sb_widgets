defmodule SbWidgetsWeb.SportsNavbarLive do
  use SbWidgetsWeb, :live_view

  def mount(params, session, socket) do
    IO.puts("Mount params #{inspect(params)} #{inspect(socket)}")
    connect_params = get_connect_params(socket)
    IO.puts("Mount params #{inspect(params)}")
    IO.puts("Mount connect_params #{inspect(connect_params)}")
    IO.puts("Mount session #{inspect(session)}")

    socket = socket |> assign_name(params, connect_params) |> assign(:active_link, "")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component
      module={SbWidgetsWeb.Components.Live.SportsNavbar}
      widget_name={@widget_name}
      active_link={@active_link}
      id="sports-nav-bar"
    />
    """
  end

  def handle_event("route_update", %{"routeParams" => route_params}, socket) do
    {:noreply, socket |> assign(:active_link, route_params["sportName"] || "")}
  end

  def handle_event("route_update", _params, socket) do
    {:noreply, socket}
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
end
