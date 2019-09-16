defmodule Indulgences.Activation.Nothing.Engine do
  use Indulgences.Activation.Engine
  alias Indulgences.Activation

  def execute(%Activation{} = activation, _) do
    duration = activation.duration
    :timer.sleep(duration)
  end
end
