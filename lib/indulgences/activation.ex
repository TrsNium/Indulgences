defmodule Indulgences.Activation do
  defstruct duration: nil, users: nil, method: nil

  def nothing(duration) do
    [%__MODULE__{duration: duration, users: 0, method: :nothing}]
  end

  def nothing(activations, duration) when is_list(activations) do
    activations ++ [%__MODULE__{duration: duration, users: 0, method: :nothing}]
  end

  def at_once(users) do
    [%__MODULE__{duration: 0, users: users, method: :at_once}]
  end

  def at_once(activations, users) when is_list(activations) do
    activations ++ [%__MODULE__{duration: 0, users: users, method: :at_once}]
  end

  def constant_users_per_sec(duration, users) do
    [%__MODULE__{duration: duration, users: users, method: :constant}]
  end

  def constant_users_per_sec(activations, duration, users) when is_list(activations) do
    activations ++ [%__MODULE__{duration: duration, users: users, method: :constant}]
  end
end
