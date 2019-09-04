
defmodule Indulgences.Activation.Engine do
  defmacro __using__(_opts) do
    quote do
      def send_report(master, report) when is_atom(master) do
        master
        |> remote_supervisor
        |> Task.Supervisor.async(Indulgences.Simulation.Supervisor, :receive_report, [report, Node.self])
      end

      defp remote_supervisor(master) do
        {Indulgences.TaskSupervisor, master}
      end
    end
  end
end
