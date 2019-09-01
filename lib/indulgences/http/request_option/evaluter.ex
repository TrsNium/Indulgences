

defmodule Indulgences.Http.RequestOptions.Evaluter do
  alias Indulgences.Http.RequestOptions

  def evalute_request_option(%RequestOptions{}=option, %{}=state) do
    evaluted_url = evalute_url(option.url, state)
    evaluted_headers = Enum.reduce(option.headers, [],
      fn({key, value}, acc) ->
        acc ++ [evalute_header({key, value}, state)]
      end)

    option
    |> Map.put(:url, evaluted_url)
    |> Map.put(:headers, evaluted_headers)
  end

  defp evalute_url(func, state) when is_function(func) do
    func.(state)
  end

  defp evalute_url(string, _) when is_binary(string), do: string

  defp evalute_url(_, _), do: raise "'url'`s type is must be string or function`"

  defp evalute_header({key, value}, state) do
    case {is_function(key), is_function(value)} do
      {true, true} -> {key.(state), value.(state)}
      {true, false} -> {key.(state), value}
      {false, true} -> {key, value.(state)}
      {false, false} -> {key, value}
    end
  end

end
