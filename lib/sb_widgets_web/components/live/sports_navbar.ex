defmodule SbWidgetsWeb.Components.Live.SportsNavbar do
  use SbWidgetsWeb, :live_component

  @links [
    %{"name" => "Featured", "slug" => ""},
    %{"name" => "Soccer", "slug" => "soccer"},
    %{"name" => "Basketball", "slug" => "basketball"},
    %{"name" => "Tennis", "slug" => "tennis"},
    %{"name" => "Baseball", "slug" => "baseball"},
    %{"name" => "Hockey", "slug" => "hockey"},
    %{"name" => "Cricket", "slug" => "cricket"},
    %{"name" => "Golf", "slug" => "golf"},
    %{"name" => "MMA", "slug" => "mma"}
  ]

  def mount(socket) do
    socket =
      socket
      |> assign(:links, @links)
      |> assign(:active_link, "")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.container widget_name={@widget_name}>
        <%= if @widget_name do %>
          <meta name={"csrf-token-#{@widget_name}"} content={Plug.CSRFProtection.get_csrf_token()} />
        <% end %>
        <p>This is LiveView widget</p>
        <div class="space-x-2 flex flex-row">
          <%= for item <- @links do %>
            <.universal_link item={item} widget_name={@widget_name} active_link={@active_link} />
          <% end %>
        </div>
      </.container>
    </div>
    """
  end

  slot :inner_block, required: true

  defp container(assigns) do
    ~H"""
    <%= if @widget_name do %>
      <div
        id={"id-#{@widget_name}"}
        data-app={"app-#{@widget_name}"}
        phx-hook={@widget_name}
        class="border-2 border-white p-4"
      >
        <%= render_slot(@inner_block) %>
      </div>
    <% else %>
      <div class="border-2 border-white p-4">
        <%= render_slot(@inner_block) %>
      </div>
    <% end %>
    """
  end

  defp universal_link(assigns) do
    ~H"""
    <%= if @widget_name do %>
      <a
        class={"ml-2 #{@item["slug"] == @active_link && "font-bold text-blue-500"}"}
        href={"/de/sports/#{@item["slug"]}"}
      >
        <%= @item["name"] %>
      </a>
    <% else %>
      <.link
        class={"ml-2 #{@item["slug"] == @active_link && "font-bold text-blue-500"}"}
        patch={~p"/url/inside/portal/#{@item["slug"]}"}
      >
        <%= @item["name"] %>
      </.link>
    <% end %>
    """
  end
end
