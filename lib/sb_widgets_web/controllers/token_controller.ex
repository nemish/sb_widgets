defmodule SbWidgetsWeb.TokenController do
  use SbWidgetsWeb, :controller

  def index(conn, _params) do
    json(conn, %{token: Plug.CSRFProtection.get_csrf_token()})
  end
end
