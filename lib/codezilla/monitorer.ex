defmodule Codezilla.Monitorer do
  use GenServer

  alias Codezilla.Flibbertigibbet, as: Monitored

  def start(opts \\ []) do
    GenServer.start(__MODULE__, opts)
  end

  def init(opts) do
    send(self(), :monitor)
    {:ok, opts}
  end

  def handle_info(:monitor, state) do
    Enum.each(:lists.seq(1, 500), fn _num ->
      Process.monitor(Monitored)
    end)
    Process.send_after(self(), :monitor, :timer.seconds(1))
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end
end
