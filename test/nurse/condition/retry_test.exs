defmodule Nurse.Test.Condition.Retry do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Nurse.Test.Generators

  describe "Nurse.Condition.Retry" do
    property "receives and returns properly typed arguments" do
      check all(
              probes_results <- Generators.probes_results(),
              retry_condition <- Generators.retry_condition()
            ) do
        assert probes_results |> Nurse.Condition.Retry.check(retry_condition) |> is_boolean()
      end
    end

    property "simple equal condition" do
      check all({successful, _failed} = probes_results <- Generators.probes_results()) do
        retry_condition = {:successful_probes_match, {:pos_integer_equal, successful}}

        assert probes_results |> Nurse.Condition.Retry.check(retry_condition)
      end
    end

    property "simple gt condition" do
      check all({successful, _failed} = probes_results <- Generators.probes_results()) do
        retry_condition = {:successful_probes_match, {:pos_integer_gt, successful - 1}}

        assert probes_results |> Nurse.Condition.Retry.check(retry_condition)
      end
    end

    property "simple gte condition" do
      check all({successful, _failed} = probes_results <- Generators.probes_results()) do
        retry_condition = {:successful_probes_match, {:pos_integer_gte, successful}}

        assert probes_results |> Nurse.Condition.Retry.check(retry_condition)
      end
    end

    property "simple lt condition" do
      check all({successful, _failed} = probes_results <- Generators.probes_results()) do
        retry_condition = {:successful_probes_match, {:pos_integer_lt, successful + 1}}

        assert probes_results |> Nurse.Condition.Retry.check(retry_condition)
      end
    end

    property "simple lte condition" do
      check all({successful, _failed} = probes_results <- Generators.probes_results()) do
        retry_condition = {:successful_probes_match, {:pos_integer_lte, successful}}

        assert probes_results |> Nurse.Condition.Retry.check(retry_condition)
      end
    end

    property "simple range condition" do
      check all({successful, _failed} = probes_results <- Generators.probes_results()) do
        retry_condition =
          {:successful_probes_match, {:pos_integer_range, successful - 1, successful + 1}}

        assert probes_results |> Nurse.Condition.Retry.check(retry_condition)
      end
    end

    property "aggregated condition" do
      check all({successful, failed} = probes_results <- Generators.probes_results()) do
        retry_condition = {
          :and,
          {:successful_probes_match, {:pos_integer_gte, successful - 1}},
          {:or, {:failed_probes_match, {:pos_integer_range, failed + 1, failed + 2}},
           {:failed_probes_match, {:pos_integer_equal, failed}}}
        }

        assert probes_results |> Nurse.Condition.Retry.check(retry_condition)
      end
    end
  end
end
