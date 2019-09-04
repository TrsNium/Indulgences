
defmodule Indulgences.Simulation.Supervisor do
  require Logger

  def receive_report(report, from) do
    Logger.info("#{inspect from}: receive report #{inspect report}")
  end
end
