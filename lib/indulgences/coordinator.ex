

defmodule Indulgences.Coordinator do
  alias Indulgences.{Simulation, Activation}

  def start(%Simulation{}=simulation) do
    execute(simulation)
  end

  defp execute(%Simulation{activation: []}=_simulation) do
    # TODO: generate report
    nil
  end

  defp execute(%Simulation{activation: [%Activation{}=activation|others], scenario: scenario, configure: nil}=_simulation) do
    case activation.method do
      :nothing -> Indulgences.Activation.Nothing.Engine.execute(activation, scenario)
      :constant -> Indulgences.Activation.Constant.Engine.execute(activation, scenario, Node.self)
    end
    execute(%Simulation{activation: others, scenario: scenario, configure: nil})
  end

  defp execute(%Simulation{activation: [activation|others], scenario: scenario, configure: configure}=_simulation) do

  end
end
