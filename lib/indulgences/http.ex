

defmodule Indulgences.Http do
  @compile if Mix.env == :test, do: :export_all
  defstruct method: nil, url: nil, headers: [], options: [], check: nil

  def get(_ \\[], url , headers \\ [], options \\ []) do
    [%__MODULE__{method: :get!, url: url, headers: headers, options: options}]
  end

  def get(other_options, url, headers, options) do
    other_options ++ [%__MODULE__{method: :get!, url: url, headers: headers, options: options}]
  end

  def post(_ \\[], url, headers \\ [], options \\ []) do
    [%__MODULE__{method: :post!, url: url, headers: headers, options: options}]
  end

  def post(other_options, url, headers, options) do
    other_options ++ [%__MODULE__{method: :post!, url: url, headers: headers, options: options}]
  end

  def set_header([%__MODULE__{}=option], key, value) do
    [update_header(option, key, value)]
  end

  def set_header([options|%__MODULE__{}=option], key, value) do
    options ++ [update_header(option, key, value)]
  end

  def check([%__MODULE__{}=option], check_fun) do
    [update_check(option, check_fun)]
  end

  def check([options|%__MODULE__{}=option], check_fun) do
    options ++ [update_check(option, check_fun)]
  end

  defp update_header(%__MODULE__{}=option, key, value) do
    headers = option.headers
    new_headers = case Enum.find_index(headers, fn {exist_key, _} -> exist_key == key end) do
      idx when is_integer(idx)-> List.delete_at(headers, idx) ++ [{key, value}]
      _ -> headers ++ [{key, value}]
    end
    Map.put(option, :headers, new_headers)
  end

  defp update_check(%__MODULE__{}=option, check) do
    Map.put(option, :check, check)
  end
end
