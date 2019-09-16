defmodule Indulgences.Simulation.Config do
  defstruct nodes_and_distribute_raito: %{}

  def new(%{} = nodes_and_distribute_raito) do
    %__MODULE__{nodes_and_distribute_raito: nodes_and_distribute_raito}
  end
end
