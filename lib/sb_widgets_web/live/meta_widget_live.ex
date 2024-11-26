defmodule SbWidgetsWeb.MetaWidgetLive do
  use SbWidgetsWeb, :live_view

  def render(assigns) do
    ~H"""
    <meta name="csrf-token" content={Plug.CSRFProtection.get_csrf_token()} />
    """
  end
end
