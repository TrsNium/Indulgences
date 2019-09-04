

defmodule Indulgences.Http do
  @compile if Mix.env == :test, do: :export_all
  defstruct method: nil, url: nil, body: "", headers: [], options: [], check: nil

  def get(url) do
    [%__MODULE__{method: :get!, url: url}]
  end

  def get(others, url) when is_list(others) do
    [others|%__MODULE__{method: :get!, url: url}]
  end

  def post(url, body) do
    [%__MODULE__{method: :post!, url: url, body: body}]
  end

  def post(others, url, body) do
    [others|%__MODULE__{method: :post!, url: url, body: body}]
  end

  def set_header([%__MODULE__{}=http], key, value) do
    [update_header(http, key, value)]
  end

  def set_header([others|%__MODULE__{}=http], key, value) do
    List.flatten(others, [update_header(http, key, value)])
  end

  #TODO: implement evalute options function
  def set_option([%__MODULE__{}=http], options) do
    [http]
  end

  def set_option([others|%__MODULE__{}=http], options) do
    List.flatten(others, [http])
  end

  def check([%__MODULE__{}=http], check_fun) do
    [update_check(http, check_fun)]
  end

  def check([others|%__MODULE__{}=http], check_fun) do
    List.flatten(others, [update_check(http, check_fun)])
  end

  def is_status(%HTTPoison.Response{}=response, desired_status_code) when is_integer(desired_status_code) do
    if response.status_code != desired_status_code do
      raise "status code is desired #{desired_status_code}, but got #{response.status_code}"
    end
  end

  def is_status(%HTTPoison.Response{}=response, desired_status_codes) when is_list(desired_status_codes) do
    if Enum.member?(desired_status_codes, response.status_code) do
      raise "status code is desired in #{inspect desired_status_codes}, but got #{response.status_code}"
    end
  end

  defp update_header(%__MODULE__{}=http, key, value) do
    headers = http.headers
    new_headers = case Enum.find_index(headers, fn {exist_key, _} -> exist_key == key end) do
      idx when is_integer(idx)-> List.delete_at(headers, idx) ++ [{key, value}]
      _ -> headers ++ [{key, value}]
    end
    Map.put(http, :headers, new_headers)
  end

  defp update_check(%__MODULE__{}=http, check) do
    Map.put(http, :check, check)
  end
end
