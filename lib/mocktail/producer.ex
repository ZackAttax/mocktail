defmodule Mocktail.Producer do
  use GenStage
  # alias Mocktail.CpiSupervisor
  alias Mocktail.BreedList
  alias Mocktail.CpiServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = %{
      breeds: [],
      demand: 0,
      breeds_to_get: BreedList.get(),
      request: 50,
      remaining_breeds: get_remaining_breeds()
    }

    {:producer, state}
  end

  def handle_info(:request, %{request: request} = state) do
    state
    |> Map.put(:request, request + 1)
    |> dispatch_breeds()
  end

  def handle_cast(
        {:add_breed, breed},
        %{breeds: breeds, remaining_breeds: remaining_breeds} =
          state
      ) do
    Process.send_after(self(), :request, 60_000)
    new_breeds = breeds ++ [breed]
    new_remaining_breeds = remaining_breeds - 1

    state
    |> Map.put(:breeds, new_breeds)
    |> Map.put(:remaining_breeds, new_remaining_breeds)
    |> dispatch_breeds()
  end

  def handle_demand(new_demand, %{demand: demand} = state) do
    state
    |> Map.put(:demand, demand + new_demand)
    |> dispatch_breeds()
  end

  def dispatch_breeds(
        %{remaining_breeds: remaining_breeds, breeds: breeds, demand: demand} = state
      )
      when remaining_breeds === 0 and demand > length(breeds) do
    new_state =
      state
      |> Map.put(:breeds, [])

    {:noreply, breeds, new_state}
  end

  def dispatch_breeds(%{breeds: breeds, demand: demand} = state) when length(breeds) >= demand do
    {breeds_to_dispatch, remaining_breeds} = Enum.split(breeds, demand)

    new_state =
      state
      |> Map.put(:demand, 0)
      |> Map.put(:breeds, remaining_breeds)

    {:noreply, breeds_to_dispatch, new_state}
  end

  def dispatch_breeds(
        %{breeds: breeds, breeds_to_get: breeds_to_get, demand: demand, request: request} = state
      )
      when length(breeds) < demand do
    {breeds_to_fetch, remaining_breeds} =
      breeds_to_get
      |> Enum.split(request)

    breeds_to_fetch
    |> Enum.each(fn breed ->
      fetch_breed(breed)
    end)

    new_state =
      state
      |> Map.put(:breeds, breeds)
      |> Map.put(:request, 0)
      |> Map.put(:breeds_to_get, remaining_breeds)

    {:noreply, [], new_state}
  end

  def fetch_breed([]) do
    Process.send_after(self(), :request, 0)
  end

  def fetch_breed(breed) do
    CpiServer.start_link(breed)
  end

  defp get_remaining_breeds() do
    remaining_breeds =
      BreedList.get()
      |> length()

    remaining_breeds
  end
end
