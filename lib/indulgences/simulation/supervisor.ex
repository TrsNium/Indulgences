
defmodule Indulgences.Simulation.Supervisor do
  use GenServer
  require Logger

  def receive_report(report, from) do
    Logger.info("#{inspect from}: receive report #{inspect report}")
  end

  def init(%Indulgences.Scenario{}=scenario) do
  end
end
