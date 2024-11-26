import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

console.log("Widget script loaded.");

window.liveSockets = {};
window.widgetsHooks = {};

const connectToLiveView = async ({ name }) => {
  console.log("Connecting to LiveSocket.");
  const liveSocket = window.liveSockets[name];
  if (liveSocket) {
    console.log("LiveSocket already connected.");
    liveSocket.disconnect();
    connectLiveSocket({ token, name });
    return;
  }

  const meta = document.querySelector(`meta[name='csrf-token-${name}']`);
  if (!meta) {
    console.log("No csrf-token found in meta tags.");
    return;
  }
  const token = meta.getAttribute("content");

  console.log("Got a token for LiveSocket", { token });

  connectLiveSocket({ token, name });
};

const connectLiveSocket = ({ token, name }) => {
  console.log("Connecting to LiveSocket with token", { token, name });
  const Hooks = {};
  Hooks[name] = {
    mounted() {
      console.log("Widget mounted.", { name });
      window.widgetsHooks[name] = this;
      window.postMessage({ type: `liveSocket:${name}:hookMounted` });
    },
  };
  let liveSocket = new LiveSocket("ws://localhost:4000/live", Socket, {
    params: { _csrf_token: token, widget_name: name },
    hooks: Hooks,
    rootViewSelector: `:has([data-app='app-${name}'])`,
  });
  liveSocket.connect();
  window.liveSockets[name] = liveSocket;
};

const pushToLiveView = ({ name, event, payload }) => {
  console.log("Hook pushing event to LiveSocket.", { name, event, payload });
  if (!window.widgetsHooks[name]) {
    console.log("Hook not established.", { name });
    return;
  }
  window.widgetsHooks[name].pushEvent(event, payload);
};

const pushRouteUpdateToLiveView = ({ name, routeParams }) => {
  pushToLiveView({
    name,
    event: "route_update",
    payload: { routeParams },
  });
};

const disconnectFromLiveView = ({ name }) => {
  console.log("Disconnecting from LiveSocket.");
  if (!window.liveSockets[name]) {
    console.log("LiveSocket not connected.");
    return;
  }
  window.liveSockets[name].disconnect();
  delete window.liveSockets[name];
};

window.connectToLiveView = connectToLiveView;
window.disconnectFromLiveView = disconnectFromLiveView;
window.pushRouteUpdateToLiveView = pushRouteUpdateToLiveView;
