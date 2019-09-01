
defmodule Indulgences.Http.RequestOptions do
  defstruct method: nil, url: nil, headers: [], options: [], check: nil

  def update_header(%__MODULE__{}=option, key, value) do
    headers = option.headers
    new_headers = case Enum.find_index(headers, fn {exist_key, _} -> exist_key == key end) do
      idx when is_integer(idx)-> List.delete_at(headers, idx) ++ [{key, value}]
      _ -> headers ++ [{key, value}]
    end
    Map.put(option, :headers, new_headers)
  end

  def update_check(%__MODULE__{}=option, check) do
    Map.put(option, :check, check)
  end
end
