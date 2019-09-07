
defmodule Indulgences.Http.Engine do
  alias Indulgences.Http
  alias Indulgences.Http.Evaluter

  @spec execute(http :: %Indulgences.Http{}, status :: %{}) :: {Time , Time , %{}}
  def execute(%Http{}=http, %{}=state) do
    evaluted_http = Evaluter.evalute_http(http, state)
    start_time = Time.utc_now()
    {status, result} = case evaluted_http.method do
      :get! -> apply(HTTPoison, :get, [evaluted_http.url, evaluted_http.headers, evaluted_http.options])
      :post! -> apply(HTTPoison, :post, [evaluted_http.url, evaluted_http.body, evaluted_http.headers, evaluted_http.options])
    end
    end_time = Time.utc_now()

    if status == :error do
      throw {start_time, end_time, result.reason}
    end

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
    {start_time, end_time,new_state}
  end
end
