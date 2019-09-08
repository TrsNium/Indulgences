defmodule Indulgences do

  @typedoc """
  This is a list of scenario instructions.
  """
  @type instructions() :: any()

  @typedoc """
  Define a list of simulation environments that execute scenarios
  """
  @type simulation_environment() :: any()

  @callback scenario() :: instructions()

  @callback activation() :: simulation_environment()

  defmacro __using__(opts) do
    scenario_description = Keyword.get(opts, :scenario_description, "Anonymous")
    scenario_function = Keyword.get(opts, :scenario, :scenario)
    activation_function = Keyword.get(opts, :activation, :activation)
    caller = __CALLER__.module

    quote location: :keep do
      @behaviour unquote(__MODULE__)
      defp get_attribute(attributes, attribute, default) do
        case Enum.find_index(attributes, fn {attribute_name, _} -> attribute_name == attribute end) do
          idx when is_integer(idx) -> {_, attribute_value} = List.pop_at(attributes, idx)
            attribute_value
          _ -> default
        end
      end

      def start() do
        attributes = apply(unquote(caller), :module_info, [])
        scenario_title = get_attribute(attributes, :scenario_title, "Anonymous")
        scenario_title = get_attribute(attributes, :scenario_description, "None")
        simulation_config = get_attribute(attributes, :simulation_config, nil)

        scenario = apply(unquote(caller), unquote(scenario_function), [])
        activation = apply(unquote(caller), unquote(activation_function), [])
        scenario = Indulgences.Scenario.new(
          scenario_title,
          unquote(scenario_description),
          scenario
        )
        simulation = Indulgences.Scenario.inject(
          scenario,
          activation
        )
        if simulation_config == nil do
          Indulgences.Simulation.start(simulation)
        else
          Indulgences.Simulation.start(simulation, simulation_config)
        end
      end
    end
  end
end
