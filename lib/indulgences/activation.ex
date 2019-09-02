defmodule Indulgences.Simulation.Activation do
  defstruct duration: nil, users: nil, method: nil

  defmacro nothing(duration) do
    [%__MODULE__{duration: duration, users: 0, method: :nothing}]
  end

  defmacro nothing(activations, duration) do
    activations ++ [%__MODULE__{duration: duration, users: 0, method: :nothing}]
  end

  defmacro at_once(users) do
    [%__MODULE__{duration: 0, users: users, method: :at_once}]
  end

  defmacro at_once(activations, users) do
    activations ++ [%__MODULE__{duration: 0, users: users, method: :at_once}]
  end

  defmacro constant_users_per_sec(duration, users) do
    [%__MODULE__{duration: duration, users: users, method: :constant}]
  end

  defmacro constant_users_per_sec(activations, duration, users) do
    activations ++ [%__MODULE__{duration: duration, users: users, method: :constant}]
  end
end
