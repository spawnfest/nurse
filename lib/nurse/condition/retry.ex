defmodule Nurse.Condition.Retry do
  alias Nurse.Condition.Health

  @spec check(Nurse.probes_results(), Nurse.retry_condition()) :: boolean()
  def check(probes_results, retry_condition), do: probes_results |> Health.check(retry_condition)
end
