defmodule NurseWeb.NewCheckLive do
    use NurseWeb, :live_view
    import Phoenix.LiveView.Helpers
    require Logger

    def mount(_params, session, socket) do
        socket = 
            assign(socket, new_condition_type: "none")
        {:ok, socket}
    end

    def handle_event(
        "add_condition_click", 
        _params,
        socket
    ) do
        socket = 
            assign(socket, new_condition_type: "choosing")
        {:noreply, socket}
    end

    def handle_event(
        "set_condition_type", 
        %{"new-condition-type" => new_condition_type, 
          "value" => _value},
        socket
    ) do
        socket = 
            assign(socket, new_condition_type: new_condition_type)
        {:noreply, socket}
    end

    def handle_event(
        "set_status_code_match", 
        %{"status-code-match" => status_code_match, 
          "value" => _value},
        socket
    ) do
        socket = 
            assign(socket, status_code_match: status_code_match)
        {:noreply, socket}
    end
end