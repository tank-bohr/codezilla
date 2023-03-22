defmodule Codezilla.Flummoxed do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    {:ok, opts}
  end

  def handle_info(_msg, state) do
    Process.sleep(:timer.seconds(1))
    {:noreply, state}
  end
end
