defmodule Indulgences.Scenario do
  defstruct name: nil, description: "No description", instructions: nil

  alias Indulgences.Simulation

  def new(name, instructions) do
    %__MODULE__{}
    |> Map.put(:name, name)
    |> Map.put(:instructions, evalute_attribute(instructions))
  end

  def new(name, description, instructions) do
    %__MODULE__{}
    |> Map.put(:name, name)
    |> Map.put(:description, description)
    |> Map.put(:instructions, evalute_attribute(instructions))
  end

  def inject(%__MODULE__{}=scenario, activation) do
      Simulation.new(scenario, evalute_attribute(activation))
  end

  defp evalute_attribute(attribute) do
    cond do
      is_list(attribute) -> attribute
      is_function(attribute) -> attribute.()
    end
  end
end
