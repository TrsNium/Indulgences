

defmodule Indulgences.Activation.Constant.Engine do
  use Indulgences.Activation.Engine
  alias Indulgences.Activation
  alias Indulgences.Scenario

  def execute(%Activation{}=activation, %Scenario{}=scenario, master) do
    end_time = Time.add(Time.utc_now, activation.duration, :second)
    total_users= activation.users*activation.duration
    exec(0, total_users, activation.duration, end_time, scenario, master)
  end

  defp exec(done_users, total_users, _, _, _, _) when done_users == total_users do
    nil
  end

  defp exec(done_users, total_users, duration, end_time, %Scenario{}=scenario, master) do
    progress_rate = 1 - (Time.diff(end_time, Time.utc_now, :second) / duration)
    desired_done_users = Kernel.trunc(progress_rate * total_users)
    # TODO: Execute scenario with background
    updated_done_users= case desired_done_users > done_users do
      true -> _ = Task.start(
                fn ->
                  send_report(master, Indulgences.Scenario.Executer.execute_scenario(scenario))
                end)
              done_users + 1
      false -> done_users
    end
    exec(updated_done_users, total_users, duration, end_time, scenario, master)
  end
end
