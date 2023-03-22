defmodule Codezilla do
  @moduledoc """
  Documentation for `Codezilla`.
  """

  alias Codezilla.Spamer
  alias Codezilla.Monitorer

  def overload(limit \\ 50) do
    1
    |> :lists.seq(limit)
    |> Enum.each(fn number ->
      Spamer.start([number: number])
    end)
  end

  def monitor() do
    Monitorer.start()
  end
end
