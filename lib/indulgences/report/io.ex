

defmodule Indulgences.Report.IO do
  alias Indulgences.Report
  def display(start_time, %Indulgences.Simulation{}=simulation) do
    {total_users, [instruction_name|_]} = GenServer.call(Indulgences.Simulation.Supervisor, :instructions)
    activations_duration = for activation <- simulation.activations ,do: activation.duration
    total_duration = Enum.sum(activations_duration)

    progress_rate = calc_progress_rate(start_time, total_duration)

    waiting_user = total_users - Indulgences.Report.get_instruction_row_count(instruction_name)
    #
    #IO.puts "#{progress_rate} #{waiting_user} #{Indulgences.Report.get_instruction_row_count(instruction_name)} #{total_users}"

    progress_resume_num = trunc(Float.floor progress_rate*10)*3
    progress_suspended_num = (30 - progress_resume_num)
    progress_bar = "#{continuous_string("#", progress_resume_num)}#{continuous_string(" ", progress_suspended_num)}%#{trunc(progress_rate*100)}"
    IO.puts """
    #{IO.ANSI.cursor_down}
    #{IO.ANSI.cursor_down}
    #{IO.ANSI.color_background(133)}#{IO.ANSI.white} PROGRESS                                      #{IO.ANSI.default_background}
    #{IO.ANSI.cursor_down}#{padding()}
    #{IO.ANSI.cursor_down}#{padding()} number_of_requests :ok :ko #{Report.ok_count()} #{Report.ko_count()}
    #{IO.ANSI.cursor_down}#{padding()} min_response_time
    #{IO.ANSI.cursor_down}#{padding()} max_response_time
    #{IO.ANSI.cursor_down}#{padding()} mean_response_time
    #{padding}#{IO.ANSI.green}#{progress_bar}
    
    """
  end

  defp padding do
    " #{IO.ANSI.color(133)}┃  #{IO.ANSI.default_color}"
  end

  defp calc_progress_rate(start_time, total_duration) do
    Time.diff(Time.utc_now, start_time) / total_duration
  end

  defp continuous_string(string, length) do
    length = if length < 0 do
      0
    else
      length
    end
    Enum.join(List.duplicate(string, length))
  end
end
