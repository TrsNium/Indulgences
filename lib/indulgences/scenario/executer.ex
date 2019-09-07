
defmodule Indulgences.Scenario.Executer do
  alias Indulgences.Scenario

  defmacrop execute_and_next(instructions, reports, do: block) do
    quote do
      try do
        {start_time, end_time, new_state} = unquote(block)
        report = {:ok, start_time, end_time, execution_time(start_time, end_time)}
        execute(unquote(instructions), new_state, unquote(reports) ++ [report])
      catch
        {start_time, end_time, reason} -> report = {:ko, start_time, end_time, execution_time(start_time, end_time), reason}
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
    execute_and_next(instructions, reports) do
      Indulgences.Http.Engine.execute(http, state)
    end
  end

  def execute_scenario(%Scenario{}=scenario) do
    instructions = scenario.instructions
    execute(instructions, %{}, [])
  end
end
