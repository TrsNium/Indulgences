
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
    # Run in background
    Task.start(fn ->
      Coordinator.start(simulation)
    end)
    display_report_until_finished(Time.utc_now, simulation)
  end

  def start(%__MODULE__{}=simulation, configure) do
    start_simulation_supervisor(simulation)
    configured_simulation = Map.put(simulation, :configure, configure)
    # Run in background
    Task.start(fn ->
      Coordinator.start(configured_simulation)
    end)
    display_report_until_finished(Time.utc_now, simulation)
  end

  defp display_report_until_finished(start_time, %__MODULE__{}=simulation) do
    if not Indulgences.Simulation.Supervisor.is_finished() do
      :timer.sleep(500)
      _ = Indulgences.Report.IO.display(start_time, simulation)
      display_report_until_finished(start_time, simulation)
    end
  end
end
