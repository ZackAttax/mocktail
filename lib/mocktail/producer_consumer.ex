defmodule Mocktail.ProducerConsumer do
  use GenStage

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [{Mocktail.Producer, max_demand: 3, min_demand: 1}]}
  end

  def handle_events(events, _from, state) do
    filtered_events =
      events
      |> Enum.reject(fn breed ->
        breed["energy_level"] < 5
      end)
      |> Enum.reject(fn breed ->
        breed["adaptability"] < 2
      end)

    {:noreply, filtered_events, state}
  end
end
