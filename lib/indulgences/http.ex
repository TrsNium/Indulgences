

defmodule Indulgences.Http do
  alias Indulgences.Http.RequestOptions


  def get(_ \\[], url, headers \\ [], options \\ []) do
    [%RequestOptions{method: :get!, url: url, headers: headers, options: options}]
  end

  def get(other_options, url, headers, options) do
    other_options ++ [%RequestOptions{method: :get!, url: url, headers: headers, options: options}]
  end

  def post(_ \\[], url, headers \\ [], options \\ []) do
    [%RequestOptions{method: :post!, url: url, headers: headers, options: options}]
  end

  def post(other_options, url, headers, options) do
    other_options ++ [%RequestOptions{method: :post!, url: url, headers: headers, options: options}]
  end

  def set_header([%RequestOptions{}=option], key, value) do
    [RequestOptions.update_header(option, key, value)]
  end

  def set_header([options|%RequestOptions{}=option], key, value) do
    options ++ [RequestOptions.update_header(option, key, value)]
  end

  def check([%RequestOptions{}=option], check_fun) do
    [RequestOptions.update_check(option, check_fun)]
  end

  def check([options|%RequestOptions{}=option], check_fun) do
    options ++ [RequestOptions.update_check(option, check_fun)]
  end
end
