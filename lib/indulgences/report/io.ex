

defmodule Indulgences.Report.IO do
  alias Indulgences.Report
  def display(start_time, %Indulgences.Simulation{}=simulation) do
    {total_users, [instruction_name|_]} = GenServer.call(Indulgences.Simulation.Supervisor, :instructions)
    activations_duration = for activation <- simulation.activations ,do: activation.duration
    total_duration = Enum.sum(activations_duration)

    progress_rate = calc_progress_rate(start_time, total_duration)

    waiting_user = total_users - Indulgences.Report.get_instruction_row_count(instruction_name)
    IO.puts "#{progress_rate} #{waiting_user} #{Indulgences.Report.get_instruction_row_count(instruction_name)} #{total_users}"
  end

  defp calc_progress_rate(start_time, total_duration) do
    Time.diff(Time.utc_now, start_time) / total_duration
  end
end
