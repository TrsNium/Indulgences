
defmodule Indulgences.Http.Engine do
  alias Indulgences.Http
  alias Indulgences.Http.Evaluter

  def execute(%Http{}=http, %{}=state) do
    evaluted_http = Evaluter.evalute_http(http, state)
    result = apply(HTTPoison, evaluted_http.method, [evaluted_http.url, evaluted_http.headers, evaluted_http.options])
    new_state = if http.check != nil do
      # Find the number of function arguments(:arity)
      case Keyword.get(Function.info(http.check), :arity) do
        1 ->
          _ = http.check.(result)
          state
        2 -> http.check.(result, state)
        _ -> raise "check function must accept one or two arguments"
      end
    end
    new_state
  end
end
