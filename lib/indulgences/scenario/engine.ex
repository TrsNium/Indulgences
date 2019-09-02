
defmodule Indulgences.Scenario.Engine do
  alias Indulgences.Scenario

  def execute([], _) do
    # may be return time, to calculate exuecutin time.
    nil
  end

  def execute([%Indulgences.Http.RequestOptions{}=option|options], state) do
    new_state = Indulgences.Http.Engine.execute(option, state)
    execute(options, new_state)
  end

  def execute_scenario(%Scenario{}=scenario) do
    instructions = scenario.instruction.()
    execute(instructions, %{})
  end
end
