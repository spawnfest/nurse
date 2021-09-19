defmodule Nurse.Test.Dets do
  use ExUnit.Case

  @foo_table :test_dets

  describe "Nurse.Dets" do
    test "inserts and exports table content as a list" do
      :ok =
        @foo_table
        |> Nurse.Dets.open_or_create()

      tuple_1 = {1, 2, 3, 4}

      tuple_2 = {5, 6, 7, 8}

      :ok =
        @foo_table
        |> Nurse.Dets.insert(tuple_1)

      :ok =
        @foo_table
        |> Nurse.Dets.insert(tuple_2)

      expected = [tuple_1, tuple_2] |> Enum.sort()
      result = @foo_table |> Nurse.Dets.table_to_list() |> Enum.sort()

      File.rm(@foo_table |> Atom.to_string())

      assert expected == result
    end
  end
end
