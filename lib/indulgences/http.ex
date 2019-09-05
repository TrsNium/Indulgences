

defmodule Indulgences.Http do
  @compile if Mix.env == :test, do: :export_all
  defstruct request_name: nil, method: nil, url: nil, body: "", headers: [], options: [], check: nil

  defp chain_http(others, %__MODULE__{}=http) do
    List.flatten([others], [http])
  end

  def new(request_name) do
    [%__MODULE__{request_name: request_name}]
  end

  def new(others, request_name) do
    chain_http(others, %__MODULE__{request_name: request_name})
  end

  def get([%__MODULE__{}=http], url) do
    [update_url_and_method_and_body(http, url, :get!)]
  end

  def get([others|[%__MODULE__{}=http]], url) do
    chain_http(others, update_url_and_method_and_body(http, url, :get!))
  end

  def post([%__MODULE__{}=http], url, body) do
    [update_url_and_method_and_body(http, url, :post!, body)]
  end

  def post([others|[%__MODULE__{}=http]], url, body) do
    chain_http(others, update_url_and_method_and_body(http, url, :post!, body))
  end

  def set_header([%__MODULE__{}=http], key, value) do
    [update_header(http, key, value)]
  end

  def set_header([others|[%__MODULE__{}=http]], key, value) do
    chain_http(others, update_header(http, key, value))
  end

  #TODO: implement evalute options function
  # ref. https://hexdocs.pm/httpoison/HTTPoison.Request.html
  def set_option([%__MODULE__{}=http], options) do
    [http]
  end

  def set_option([others|[%__MODULE__{}=http]], options) do
    List.flatten(others, [http])
  end

  def check([%__MODULE__{}=http], check_fun) do
    [update_check(http, check_fun)]
  end

  def check([others|[%__MODULE__{}=http]], check_fun) do
    chain_http(others, update_check(http, check_fun))
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

  defp update_url_and_method_and_body(%__MODULE__{}=http, url, method, body \\ "") do
    http
    |> Map.put(:method, method)
    |> Map.put(:url, url)
    |> Map.put(:body, body)
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
