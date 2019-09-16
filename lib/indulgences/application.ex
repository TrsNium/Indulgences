defmodule Indulgences.Application do
  use Application

  def start(_type, _args) do
    # Start Mnesia
    Memento.start()
    Memento.Table.create!(Indulgences.Report)

    # Start TaskSupervisor
    children = [
      {Task.Supervisor, name: Indulgences.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Indulgences.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
