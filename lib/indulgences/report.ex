defmodule Indulgences.Report do
  use Memento.Table,
    attributes: [
      :id,
      :instruction_name,
      :status,
      :reason,
      :start_time,
      :end_time,
      :execution_time
    ],
    index: [:instruction_name, :status, :reason, :start_time, :end_time],
    type: :ordered_set,
    autoincrement: true

  def write(instruction_name, status, reason, start_time, end_time, execution_time) do
    Memento.transaction(fn ->
      Memento.Query.write(%__MODULE__{
        instruction_name: instruction_name,
        status: status,
        reason: reason,
        start_time: start_time,
        end_time: end_time,
        execution_time: execution_time
      })
    end)
  end

  def get_instruction_row_count(instruction_name) do
    rows =
      Memento.transaction!(fn ->
        Memento.Query.select(__MODULE__, {:==, :instruction_name, instruction_name})
      end)

    Enum.count(rows)
  end

  def count_rows(status) do
    Enum.count(get_rows(status))
  end

  def min_response_time(status) do
    min =
      get_rows(status)
      |> Enum.map(fn %__MODULE__{} = report -> report.execution_time end)
      |> Enum.min()

    trunc(min / 1000)
  end

  def max_response_time(status) do
    max =
      get_rows(status)
      |> Enum.map(fn %__MODULE__{} = report -> report.execution_time end)
      |> Enum.max()

    trunc(max / 1000)
  end

  def mean_response_time(status) do
    rows = get_rows(status)

    total_execution_time =
      rows
      |> Enum.map(fn %__MODULE__{} = report -> report.execution_time end)
      |> Enum.sum()

    trunc(total_execution_time / Enum.count(rows) / 1000)
  end

  defp get_rows(status) do
    rows =
      Memento.transaction!(fn ->
        Memento.Query.select(__MODULE__, {:==, :status, status})
      end)

    if rows == [] do
      [%__MODULE__{execution_time: 0}]
    else
      rows
    end
  end

  def clear() do
    Memento.Table.delete!(__MODULE__)
    Memento.Table.create!(__MODULE__)
  end
end
