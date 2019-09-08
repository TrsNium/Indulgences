
defmodule Indulgences.Simulation do
  alias Indulgences.{Scenario, Coordinator}
  defstruct [
    scenario: nil,
    activation: nil,
    configure: nil
  ]

  def new(%Scenario{}=scenario, activation) do
    %__MODULE__{}
    |> Map.put(:scenario, scenario)
    |> Map.put(:activation, activation)
  end

  defp start_simulation_supervisor(%__MODULE__{}=simulation) do
    child = [
        %{
          id: Indulgences.Simulation.Supervisor,
          start: {Indulgences.Simulation.Supervisor, :start_link, [simulation.scenario]}
        }
    ]
    {:ok, _pid} = Supervisor.start_link(child, strategy: :one_for_one)
  end

  def start(%__MODULE__{}=simulation) do
    start_simulation_supervisor(simulation)
    Coordinator.start(simulation)
  end

  def start(%__MODULE__{}=simulation, configure) do
    start_simulation_supervisor(simulation)
    configured_simulation = Map.put(simulation, :configure, configure)
    Coordinator.start(configured_simulation)
  end
end
