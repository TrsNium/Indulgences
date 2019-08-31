

defmodule Indulgences.Coordinator do
  use GenServer
  defstruct request: nil, instruction_destination: nil

  def new(request, instruction_destination) do
    %__MODULE__{}
    |> Map.put(:request, request)
    |> Map.put(:instruction_destination, instruction_destination)
  end

  def start(%__MODULE__{}=opts) do
    # TODO: send instruction whhich is http request to other nodes
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    {:ok, opts}
  end
end
