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

  defmacro __using__(_opts) do
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
        scenario_description = get_attribute(attributes, :scenario_description, "None")
        simulation_config = get_attribute(attributes, :simulation_config, nil)

        instructions = apply(unquote(caller), :scenario, [])
        activations = apply(unquote(caller), :activation, [])
        scenario = Indulgences.Scenario.new(
          scenario_title,
          scenario_description,
          instructions
        )
        simulation = Indulgences.Scenario.inject(
          scenario,
          activations
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
