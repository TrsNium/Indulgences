defmodule Indulgences.Report.IO do
  alias Indulgences.Report

  def display(start_time, %Indulgences.Simulation{} = simulation) do
    {total_users, [instruction_name | _]} =
      GenServer.call(Indulgences.Simulation.Supervisor, :instructions)

    activations_duration = for activation <- simulation.activations, do: activation.duration
    total_duration = Enum.sum(activations_duration)

    progress_rate = calc_progress_rate(start_time, total_duration)

    progress_rate =
      if progress_rate > 1.0 do
        1.0
      else
        progress_rate
      end

    [ok_count, ok_min_resp, ok_max_resp, ok_mean_resp] =
      format_report_terms([
        Report.count_rows(:ok),
        Report.min_response_time(:ok),
        Report.max_response_time(:ok),
        Report.mean_response_time(:ok)
      ])

    [ko_count, ko_min_resp, ko_max_resp, ko_mean_resp] =
      format_report_terms([
        Report.count_rows(:ko),
        Report.min_response_time(:ko),
        Report.max_response_time(:ko),
        Report.mean_response_time(:ko)
      ])

    waiting_user = total_users - Indulgences.Report.get_instruction_row_count(instruction_name)
    progress_resume_num = trunc(Float.floor(progress_rate * 10)) * 3
    progress_suspended_num = 30 - progress_resume_num

    progress_bar =
      "#{continuous_string("#", progress_resume_num)}#{
        continuous_string(" ", progress_suspended_num)
      }%#{trunc(progress_rate * 100)}"

    IO.puts("""
    #{IO.ANSI.cursor_down()}
    #{IO.ANSI.cursor_down()}
    #{IO.ANSI.color_background(133)}#{IO.ANSI.white()} PROGRESS                                      #{
      IO.ANSI.default_background()
    }
    #{IO.ANSI.cursor_down()}#{padding()}
    #{IO.ANSI.cursor_down()}#{padding()} number_of_requests :ok :ko #{ok_count} #{ko_count}
    #{IO.ANSI.cursor_down()}#{padding()} min_response_time(ms)      #{ok_min_resp} #{ko_min_resp}
    #{IO.ANSI.cursor_down()}#{padding()} max_response_time(ms)      #{ok_max_resp} #{ko_max_resp}
    #{IO.ANSI.cursor_down()}#{padding()} mean_response_time(ms)     #{ok_mean_resp} #{
      ko_mean_resp
    }
    #{padding}#{IO.ANSI.green()}#{progress_bar}

    """)
  end

  defp padding do
    " #{IO.ANSI.color(133)}┃  #{IO.ANSI.default_color()}"
  end

  defp calc_progress_rate(start_time, total_duration) do
    Time.diff(Time.utc_now(), start_time) / total_duration
  end

  defp continuous_string(string, length) do
    length =
      if length < 0 do
        0
      else
        length
      end

    Enum.join(List.duplicate(string, length))
  end

  defp format_report_terms(report_terms) do
    converted_string =
      report_terms
      |> Enum.map(&Integer.to_string(&1))

    max_length =
      converted_string
      |> Enum.map(&String.length(&1))
      |> Enum.max()

    formated_report_terms(converted_string, max_length, [])
  end

  defp formated_report_terms([], _, report) do
    report
  end

  defp formated_report_terms([term | others], max_length, report) do
    formated_report_terms(
      others,
      max_length,
      report ++ [String.pad_leading(term, max_length, " ")]
    )
  end
end
