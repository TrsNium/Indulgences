
defmodule Indulgences.Simulation.Supervisor do
  use GenServer
  require Logger
  alias Indulgences.Report

  def receive_report(report) do
    write_report(report)
  end

  def receive_report(report, _from) do
    write_report(report)
  end

  defp write_report(report) do
    {_, instructions_name} = GenServer.call(__MODULE__, :instructions)
    instructions_report = Enum.zip([report, instructions_name])
    Enum.each(instructions_report,
      fn({{status, start_time, end_time, execution_time, reason}, instruction_name}) ->
        Report.write(instruction_name, status, reason, start_time, end_time, execution_time)
      end)
  end

  def is_finished() do
    {total_users, [instruction_name|_]} = GenServer.call(__MODULE__, :instructions)
    total_users == Report.get_instruction_row_count(instruction_name)
  end

  @impl true
  def handle_call(:instructions, _from, instructions_name) do
    {:reply, instructions_name, instructions_name}
  end

  def start_link(%Indulgences.Simulation{}=simulation) do
    GenServer.start_link(__MODULE__, simulation, name: __MODULE__)
  end

  @impl true
  def init(%Indulgences.Simulation{}=simulation) do
    instructions_name = for instruct <- simulation.scenario.instructions ,do: instruct.name
    activations_users_in_duration = for activation <- simulation.activations ,do: activation.users * activation.duration
    total_users = Enum.sum(activations_users_in_duration)
    {:ok, {total_users, instructions_name}}
  end
end
