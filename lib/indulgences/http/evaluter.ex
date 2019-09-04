

defmodule Indulgences.Http.Evaluter do
  alias Indulgences.Http

  def evalute_http(%Http{}=http, %{}=state) do
    evaluted_url = evalute(http.url, state)
    evaluted_body = evalute(http.body, state)
    evaluted_headers = Enum.reduce(http.headers, [],
      fn({key, value}, acc) ->
        acc ++ [evalute_header({key, value}, state)]
      end)

    http
    |> Map.put(:url, evaluted_url)
    |> Map.put(:body, evaluted_body)
    |> Map.put(:headers, evaluted_headers)
  end

  defp evalute(func, state) when is_function(func) do
    func.(state)
  end

  defp evalute(string, _) when is_binary(string), do: string

  defp evalute(_, _), do: raise "'url'`s type is must be string or function`"

  defp evalute_header({key, value}, state) do
    case {is_function(key), is_function(value)} do
      {true, true} -> {key.(state), value.(state)}
      {true, false} -> {key.(state), value}
      {false, true} -> {key, value.(state)}
      {false, false} -> {key, value}
    end
  end

end
