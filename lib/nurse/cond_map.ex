defmodule Nurse.CondMap do

    def put_new_son_of(map, "0", "simple") when map == %{} do
        %{key: "simple", condition_id: "0S", params: %{}}
    end

    def put_new_son_of(map, "0", son_type) when map == %{}do
        %{
            key: son_type,
            condition_id: "0"<>get_type_id(son_type),
            fst: %{},
            snd: %{}
        }
    end

    def update_condition_params(map, condition_id, update) when map == %{} do
        {:error, :empty_map}
    end

    def update_condition_params(%{
        key: key,
        condition_id: condition_id,
        fst: first,
        snd: second
    }, condition_id, update) do
        {:error, :wrong_id}
    end

    def update_condition_params(%{
        key: key,
        condition_id: condition_id,
        params: params
    }, condition_id, update) do
        %{
            key: key,
            condition_id: condition_id,
            params: Map.merge(params, update)
        }
    end

    def update_condition_params(%{
        key: key,
        condition_id: parent_id,
        fst: first,
        snd: second
    }, condition_id, update) do
        case update_condition_params(first, condition_id, update) do
            error when error in [{:error, :empty_map}, {:error, :wrong_path}, {:error, :wrong_id}] ->
                case update_condition_params(second, condition_id, update) do
                    error when error in [{:error, :empty_map}, {:error, :wrong_path}, {:error, :wrong_id}] ->
                        error
                    map ->
                        %{
                            key: key,
                            condition_id: parent_id,
                            fst: first,
                            snd: map
                        }
                end
            map ->
                %{
                    key: key,
                    condition_id: parent_id,
                    fst: map,
                    snd: second
                }
        end
    end

    def put_new_son_of(%{
        key: key,
        condition_id: parent_id,
        fst: %{},
        snd: second
    }, parent_id, son_type) do
        %{
            key: key,
            condition_id: parent_id,
            fst: put_new_son_of(%{}, parent_id, son_type, :first),
            snd: second
        } 
    end

    def put_new_son_of(%{
        key: key,
        condition_id: parent_id,
        fst: first,
        snd: %{}
    }, parent_id, son_type) do
        %{
            key: key,
            condition_id: parent_id,
            fst: first,
            snd: put_new_son_of(%{}, parent_id, son_type, :second)
        } 
    end

    def put_new_son_of(%{
        key: key,
        condition_id: parent_id,
        fst: first,
        snd: second
    }, parent_id, son_type) do
        {:error, :bad_arg, "Parent has 2 childs already"}
    end

    def put_new_son_of(%{
        key: key,
        condition_id: condition_id,
        fst: first,
        snd: second
    }, parent_id, son_type) do
        condition_id_len = String.length(condition_id)
        << head :: binary-size(condition_id_len) >> <> rest = parent_id
        case head do
            condition_id ->
                case put_new_son_of(first, parent_id, son_type) do
                    {:error, wrong_path} ->
                        case put_new_son_of(second, parent_id, son_type) do
                            {:error, wrong_path} ->
                                {:error, wrong_path}
                            map ->
                                %{
                                    key: key,
                                    condition_id: condition_id,
                                    fst: first,
                                    snd: map
                                }
                        end
                    map ->
                        %{
                            key: key,
                            condition_id: condition_id,
                            fst: map,
                            snd: second
                        }
                end
            _ ->
                {:error, :wrong_path}
        end
    end

    def put_new_son_of(map, parent_id, son_type, :first) when map == %{} do
        %{
            key: son_type,
            condition_id: parent_id<>"1"<>get_type_id(son_type)    
        } |>
        Maps.merge(get_son_default_map(son_type))
    end

    def put_new_son_of(map, parent_id, son_type, :second) when map == %{} do
        %{
            key: son_type,
            condition_id: parent_id<>"2"<>get_type_id(son_type)
        } |>
        Maps.merge(get_son_default_map(son_type))
    end

    defp get_type_id("simple") do
        "S"
    end
    defp get_type_id("and") do
        "A"
    end
    defp get_type_id("or") do
        "O"
    end

    defp get_son_default_map("simple") do
        %{params: %{}}
    end
    defp get_son_default_map(other) do
        %{fst: %{}, snd: %{}}
    end

end