defmodule NurseWeb.CheckConditionView do
    use NurseWeb, :view

    def render("condition.html", %{condition_map: %{key: key, condition_id: condition_id, fst: first, snd: second}}) do
        Phoenix.View.render(NurseWeb.CheckConditionView, "agg_condition.html", %{condition_id: condition_id, first: first, second: second})
    end

    def render("condition.html", %{condition_map: %{key: key, condition_id: condition_id, params: params}}) do
        Phoenix.View.render(NurseWeb.CheckConditionView, "simple_condition.html", %{condition_id: condition_id, params: params})
    end
  end
  