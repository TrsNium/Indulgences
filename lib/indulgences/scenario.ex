defmodule Indulgences.Scenario do
  defstruct name: nil, description: nil, instruction: nil

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
end
