defmodule NurseWeb.NewCheckLive do
    use NurseWeb, :live_view
    import Phoenix.LiveView.Helpers
    require Logger

    def mount(_params, session, socket) do
        socket = 
            assign(socket, new_condition_type: "none") |>
            assign(condition_map: %{}) |>
            assign(condition_branch: [])
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
        "add_condition",
        %{"condition-type" => "simple",
          "condition-id" => parent_condition_id,
          "value" => _value},
        socket
    ) do
        new_map = Nurse.CondMap.put_new_son_of(socket.assigns.condition_map, parent_condition_id, "simple")
        socket =
            assign(socket, condition_map: new_map)
        {:noreply, socket}
    end

    def handle_event(
        "add_condition",
        %{"condition-type" => condition_type,
          "condition-id" => parent_condition_id,
          "value" => _value},
        socket
    ) do
        new_map = socket.assigns.condition_map |>
            Nurse.CondMap.put_new_son_of(parent_condition_id, condition_type)
        socket =
            assign(socket, condition_map: new_map)
        {:noreply, socket}
    end

    def handle_event(
        "set_condition_type", 
        %{"new-condition-type" => new_condition_type,
          "new-condition-for-condition" => condition_id,
          "value" => _value},
        socket
    ) do
        new_map = 
            Nurse.CondMap.update_condition_params(socket.assigns.condition_map, condition_id, %{condition_type: new_condition_type})
        IO.inspect(new_map)
        socket =
            assign(socket, condition_map: new_map)   
        {:noreply, socket}
    end

    def handle_event(
        "set_status_code_match",
        %{"status-code-match" => status_code_match,
          "new-condition-for-condition" => condition_id,
          "value" => _value},
        socket
    ) do
        new_map = socket.assigns.condition_map |>
            Nurse.CondMap.update_condition_params(condition_id, %{status_code_match: status_code_match})
        socket =
            assign(socket, condition_map: new_map)
        {:noreply, socket}
    end
end