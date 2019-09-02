
defmodule Indulgences.Http.Engine do
  alias Indulgences.Scenario
  alias Indulgences.Http.RequestOptions
  alias Indulgences.Http.RequestOptions.Evaluter

  def execute(%RequestOptions{}=option, %{}=state) do
    evaluted_option = Evaluter.evalute_request_option(option, state)
    result = apply(HTTPoison, evaluted_option.method, [evaluted_option.url, evaluted_option.headers, evaluted_option.options])
    new_state = if option.check != nil do
      # Find the number of function arguments(:arity)
      case Keyword.get(Function.info(option.check), :arity) do
        1 ->
          _ = option.check.(result)
          state
        2 -> option.check.(result, state)
        _ -> raise "check function must accept one or two arguments"
      end
    end
    new_state
  end
end
