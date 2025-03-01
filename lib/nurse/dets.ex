defmodule Nurse.Dets do
  @type table :: atom()

  @spec open_or_create(table(), Keyword.t()) :: :ok | :error
  def open_or_create(table, opts \\ []) do
    case :dets.open_file(table, opts) do
      {:ok, _table} -> :ok
      {:error, _reason} -> :error
    end
  end

  @spec insert(table(), tuple()) :: :ok | :error
  def insert(table, objects) do
    case :dets.insert(table, objects) do
      {:error, _reason} -> :error
      _ok -> :ok
    end
  end

  @spec table_to_list(table()) :: [tuple()]
  def table_to_list(table) do
    fn x, acc -> [x | acc] end
    |> :dets.foldr([], table)
  end
end
