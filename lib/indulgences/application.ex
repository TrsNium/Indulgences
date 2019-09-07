

defmodule Indulgences.Application do
  use Application

  def start(_type, _args) do
    # Start Mnesia
    :mnesia.start()
    :mnesia.create_table(:report, [
      attributes: [
        :individual_scenario,
        :status,
        :reason,
        :start_time,
        :end_time,
        :execution_time
      ]
    ])

    # Start TaskSupervisor
    children = [
      {Task.Supervisor, name: Indulgences.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Indulgences.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
