defmodule Indulgences.Activation.Constant.Engine do
  use Indulgences.Activation.Engine
  alias Indulgences.Activation
  alias Indulgences.Scenario

  def execute(%Activation{} = activation, %Scenario{} = scenario, master) do
    microsecond_duration = activation.duration * 1_000_000
    end_time = Time.add(Time.utc_now(), microsecond_duration, :microsecond)
    total_users = activation.users * activation.duration
    exec(0, total_users, microsecond_duration, end_time, scenario, master)
  end

  defp exec(done_users, total_users, _, _, _, _) when done_users == total_users do
    nil
  end

  defp exec(done_users, total_users, duration, end_time, %Scenario{} = scenario, master) do
    progress_rate = 1 - Time.diff(end_time, Time.utc_now(), :microsecond) / duration
    desired_done_users = Kernel.trunc(progress_rate * total_users)
    # TODO: Execute scenario with background
    updated_done_users =
      case desired_done_users > done_users do
        true ->
          _ =
            Task.start(fn ->
              send_report(master, Indulgences.Scenario.Executer.execute_scenario(scenario))
            end)

          done_users + 1

        false ->
          done_users
      end

    exec(updated_done_users, total_users, duration, end_time, scenario, master)
  end
end
