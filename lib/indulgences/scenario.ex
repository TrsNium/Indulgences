defmodule Indulgences.Scenario do
  defstruct name: nil, description: "No description", instruction: nil

  alias Indulgences.Simulation
  require Indulgences.Simulation.Activation

  def new(name, processes) do
    %__MODULE__{}
    |> Map.put(:name, name)
    |> Map.put(:instruction, processes)
  end

  def new(name, description, processes) do
    %__MODULE__{}
    |> Map.put(:name, name)
    |> Map.put(:description, description)
    |> Map.put(:instruction, processes)
  end

  def inject(%__MODULE__{}=scenario, activation) when is_function(activation) do
      Simulation.new(scenario, activation.())
  end

  def inject(%__MODULE__{}=scenario, activation) when is_list(activation) do
      Simulation.new(scenario, activation)
  end
end
