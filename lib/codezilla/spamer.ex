defmodule Codezilla.Spamer do
  use GenServer

  alias Codezilla.Flummoxed, as: Overloaded

  def start(opts) do
    GenServer.start(__MODULE__, opts)
  end

  def init(opts) do
    send(self(), :spam)
    {:ok, opts}
  end

  def handle_info(:spam, state) do
    send(Overloaded, {:msg, make_ref()})
    Process.send_after(self(), :spam, :timer.seconds(1))
    {:noreply, state}
  end
end
