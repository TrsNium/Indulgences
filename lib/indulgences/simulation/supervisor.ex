
defmodule Indulgences.Simulation.Supervisor do
  use GenServer
  require Logger
  alias Indulgences.Report

  def receive_report(report) do
    insert_report(report)
  end

  def receive_report(report, _from) do
    insert_report(report)
  end

  defp insert_report(report) do
    instructions_name = GenServer.call(__MODULE__, :instructions_name)
    instructions_report = Enum.zip([report, instructions_name])
    Enum.each(instructions_report,
      fn({{status, start_time, end_time, execution_time, reason}, instruction_name}) ->
        Report.insert_report(instruction_name, status, reason, start_time, end_time, execution_time)
      end)
  end

  #TODO
  def is_finished() do

  end

  @impl true
  def handle_call(:instructions_name, _from, instructions_name) do
    {:reply, instructions_name, instructions_name}
  end

  def start_link(%Indulgences.Scenario{}=scenario) do
    GenServer.start_link(__MODULE__, scenario, name: __MODULE__)
  end

  @impl true
  def init(%Indulgences.Scenario{}=scenario) do
    instructions_name = for instruct <- scenario.instructions ,do: instruct.name
    {:ok, instructions_name}
  end
end
