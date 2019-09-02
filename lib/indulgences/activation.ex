defmodule Indulgences.Simulation.Activation do
  defstruct duration: nil, users: nil, method: nil

  defmacro nothingFor(duration) do
    [%__MODULE__{duration: duration, users: 0, method: :nothing}]
  end

  defmacro nothingFor(activations, duration) do
    activations ++ [%__MODULE__{duration: duration, users: 0, method: :nothing}]
  end

  defmacro atOnceUsers(users) do
    [%__MODULE__{duration: 0, users: users, method: :atOnce}]
  end

  defmacro atOnceUsers(activations, users) do
    activations ++ [%__MODULE__{duration: 0, users: users, method: :atOnce}]
  end

  defmacro constantUsersPerSec(duration, users) do
    [%__MODULE__{duration: duration, users: users, method: :constant}]
  end

  defmacro constantUsersPerSec(activations, duration, users) do
    activations ++ [%__MODULE__{duration: duration, users: users, method: :constant}]
  end
end
