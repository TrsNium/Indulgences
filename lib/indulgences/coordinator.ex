defmodule Indulgences.Coordinator do
  alias Indulgences.{Simulation, Activation}

  def start(%Simulation{} = simulation) do
    execute(simulation)
  end


  defp execute(
         %Simulation{
           activations: [%Activation{} = activation | others],
           scenario: scenario,
           configure: nil
         } = _simulation
       ) do
    case activation.method do
      :nothing ->
        Indulgences.Activation.Nothing.Engine.execute(activation, scenario)

      :constant ->
        Indulgences.Activation.Constant.Engine.execute(activation, scenario, Node.self())
    end

    execute(%Simulation{activations: others, scenario: scenario, configure: nil})
  end

  defp execute(%Simulation{
         activations: [activation | others],
         scenario: scenario,
         configure: configure
       }) do
    divided_users = divide_user_along_ratio(activation.users, configure)

    divided_users
    |> Map.to_list()
    |> Enum.each(fn users ->
      execute_scenario_on_remote(users, activation, scenario)
    end)

    :timer.sleep(activation.duration)
    execute(%Simulation{activations: others, scenario: scenario, configure: configure})
  end

  defp execute(_) do
    nil
  end

  defp execute_scenario_on_remote({dest, users}, activation, scenario) do
    updated_users = Map.put(activation, :users, users)

    case activation.method do
      :nothing ->
        remote_supervisor(dest)
        |> Task.Supervisor.async(Indulgences.Activation.Nothing.Engine, :execute, [
          updated_users,
          scenario
        ])

      :constant ->
        remote_supervisor(dest)
        |> Task.Supervisor.async(Indulgences.Activation.Constant.Engine, :execute, [
          updated_users,
          scenario,
          Node.self()
        ])
    end
  end

  defp remote_supervisor(address) do
    {Indulgences.TaskSupervisor, address}
  end

  defp divide_user_along_ratio(total_users, configure) do
    initialized_users_per_nodes =
      configure.nodes_and_distribute_raito
      |> Map.keys
      |> Enum.reduce(%{}, fn key, acc -> Map.put(acc, key, 0) end)

    total_ratio =
      Map.values(configure.nodes_and_distribute_raito)
      |> Enum.sum()

    divided_users =
      Map.keys(initialized_users_per_nodes)
        |> Enum.reduce(initialized_users_per_nodes, fn key, acc ->
          ratio = Map.get(configure.nodes_and_distribute_raito, key) / total_ratio
          Map.put(acc, key, trunc(total_users * ratio))
        end)

    diff = total_users - Enum.sum(Map.values(divided_users))

    if diff != 0 do
      self_node_users = Map.get(divided_users, Node.self(), 0)
      Map.put(divided_users, Node.self(), self_node_users + diff)
    else
      divided_users
    end
  end
end
