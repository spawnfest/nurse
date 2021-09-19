defmodule Nurse.Condition.Health do
  @spec check(Nurse.probes_results(), Nurse.health_condition()) :: boolean()
  def check(probes_results, {:not, health_condition}),
    do: !check(probes_results, health_condition)

  def check(probes_results, {:and, health_condition_1, health_condition_2}),
    do: check(probes_results, health_condition_1) and check(probes_results, health_condition_2)

  def check(probes_results, {:or, health_condition_1, health_condition_2}),
    do: check(probes_results, health_condition_1) or check(probes_results, health_condition_2)

  def check(
        {successful_probes, _failed_probes},
        {:successful_probes_match, succesful_probes_match}
      ),
      do: pos_integer_match(successful_probes, succesful_probes_match)

  def check({_successful_probes, failed_probes}, {:failed_probes_match, failed_probes_match}),
    do: pos_integer_match(failed_probes, failed_probes_match)

  def check(_probes_results, _Condition), do: false

  @spec pos_integer_match(pos_integer(), Nurse.pos_integer_match()) :: boolean()
  defp pos_integer_match(input, {:pos_integer_equal, input}), do: true
  defp pos_integer_match(input, {:pos_integer_gt, pos_integer}) when input > pos_integer, do: true

  defp pos_integer_match(input, {:pos_integer_gte, pos_integer}) when input >= pos_integer,
    do: true

  defp pos_integer_match(input, {:pos_integer_lt, pos_integer}) when input < pos_integer, do: true

  defp pos_integer_match(input, {:pos_integer_lte, pos_integer}) when input <= pos_integer,
    do: true

  defp pos_integer_match(input, {:pos_integer_range, first, last}) when input in first..last,
    do: true

  defp pos_integer_match(_input, _pos_integer_match), do: false
end
