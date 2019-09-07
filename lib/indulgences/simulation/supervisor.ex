
defmodule Indulgences.Simulation.Supervisor do
  use GenServer
  require Logger

  def receive_report(report, from) do
    Logger.info("#{inspect from}: receive report #{inspect report}")
  end

  def start_link(scenario) do
    GenServer.start_link(__MODULE__, scenario, name: __MODULE__)
  end

  def init(%Indulgences.Scenario{}=scenario) do
    instructions_count = for instruct <- scenario.instructions ,do: {instruct.name, 0}
    {:ok, instructions_count}
  end
end
