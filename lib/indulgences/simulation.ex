
defmodule Indulgences.Simulation do
  alias Indulgences.{Scenario, Coordinator}
  defstruct [
    scenario: nil,
    activation: nil,
    configure: nil
  ]

  def new(%Scenario{}=scenaio, activation) do
    %__MODULE__{}
    |> Map.put(:scenario, scenaio)
    |> Map.put(:activation, activation)
  end

  def start(%__MODULE__{}=simulation) do
    Coordinator.start(simulation)
  end

  def start(%__MODULE__{}=simulation, configure) do
    configured_simulation = Map.put(simulation, :configure, configure)
    Coordinator.start(configured_simulation)
  end
end
