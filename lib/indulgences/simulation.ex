
defmodule Indulgences.Simulation do
  alias Indulgences.{Scenario, Coordinator}
  defstruct [
    scenario: nil,
    activations: nil,
    configure: nil
  ]

  def new(%Scenario{}=scenario, activation) do
    %__MODULE__{}
    |> Map.put(:scenario, scenario)
    |> Map.put(:activations, activation)
  end

  defp start_simulation_supervisor(%__MODULE__{}=simulation) do
    child = [
        %{
          id: Indulgences.Simulation.Supervisor,
          start: {Indulgences.Simulation.Supervisor, :start_link, [simulation]}
        }
    ]
    {:ok, _pid} = Supervisor.start_link(child, strategy: :one_for_one)
  end

  def start(%__MODULE__{}=simulation) do
    start_simulation_supervisor(simulation)
    Coordinator.start(simulation)
    display_report_until_finished
  end

  def start(%__MODULE__{}=simulation, configure) do
    start_simulation_supervisor(simulation)
    configured_simulation = Map.put(simulation, :configure, configure)
    Coordinator.start(configured_simulation)
    display_report_until_finished
  end

  defp display_report_until_finished() do
    if not Indulgences.Simulation.Supervisor.is_finished() do
      
    end
  end
end
