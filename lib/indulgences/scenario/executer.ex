
defmodule Indulgences.Scenario.Executer do
  alias Indulgences.Scenario

  defmacrop next(instructions, reports, do: block) do
    quote do
      start_time = Time.utc_now
      try do
        new_state = unquote(block)
        report = {:ok, execution_time(start_time, Time.utc_now)}
        execute(unquote(instructions), new_state, unquote(reports) ++ [report])
      rescue
        error -> report = {:ko, execution_time(start_time, Time.utc_now)}
                 execute([], nil, unquote(reports) ++ [report])
      end
    end
  end

  defp execution_time(start_time, end_time) do
    Time.diff(end_time, start_time, :microsecond)
  end

  def execute([], _, reports) do
    reports
  end

  def execute([%Indulgences.Http{}=http|instructions], state, reports) do
    next(instructions, reports) do
      Indulgences.Http.Engine.execute(http, state)
    end
  end

  def execute_scenario(%Scenario{}=scenario) do
    instructions = scenario.instructions.()
    execute(instructions, %{}, [])
  end
end
