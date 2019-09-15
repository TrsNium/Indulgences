defmodule Indulgences.Report do
  use Memento.Table,
    attributes: [:id, :instruction_name, :status, :reason, :start_time, :end_time, :execution_time],
    index: [:instruction_name, :status, :reason, :start_time, :end_time],
    type: :ordered_set,
    autoincrement: true

  def write(instruction_name, status, reason, start_time, end_time, execution_time) do
    Memento.transaction fn ->
      Memento.Query.write(%__MODULE__{
        instruction_name: instruction_name,
        status: status,
        reason: reason,
        start_time: start_time,
        end_time: end_time,
        execution_time: execution_time
      })
    end
  end

  def get_instruction_row_count(instruction_name) do
    rows = Memento.transaction! fn ->
      Memento.Query.select(__MODULE__, {:==, :instruction_name, instruction_name})
    end
    Enum.count(rows)
  end

  def ok_count do
    rows = Memento.transaction! fn ->
      Memento.Query.select(__MODULE__, {:==, :status, :ok})
    end
    Enum.count(rows)
  end

  def ko_count do
    rows = Memento.transaction! fn ->
      Memento.Query.select(__MODULE__, {:==, :status, :ko})
    end
    Enum.count(rows)
  end
end
