
defmodule Indulgences.Scenario.Engine do
  alias Indulgences.Scenario

  def execute([], _) do
    # may be return time, to calculate exuecutin time.
    nil
  end

  def execute([%Indulgences.Http{}=http|instructions], state) do
    new_state = Indulgences.Http.Engine.execute(http, state)
    execute(instructions, new_state)
  end

  def execute_scenario(%Scenario{}=scenario) do
    instructions = scenario.instruction.()
    execute(instructions, %{})
  end
end
