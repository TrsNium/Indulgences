

defmodule Indulgences.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Indulgences.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Indulgences.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
