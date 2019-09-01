
defmodule Indulgences.Engine do
  alias Indulgences.Scenario
  alias Indulgences.Http.RequestOptions

  def execute([], state) do
    IO.puts inspect state
  end

  def execute([%RequestOptions{}=option | options], %{}=state) do
    result = apply(HTTPoison, option.method, [option.url, option.headers, option.options])
    IO.puts inspect option
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
    execute(options, new_state)
  end

  def exute_scenario(%Scenario{}=scenario) do
    state = %{}
    processes = scenario.instruction.()
    execute processes, state
  end
end
