defmodule Mocktail.CatBreedServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def get(breed) do
    GenServer.call(__MODULE__, {:get_breed, breed})
  end

  def handle_cast({:add_cat, %{breed: breed, cat_name: cat_name}}, state) do
    new_state =
      state
      |> Map.update(breed, [cat_name], fn cats ->
        cats ++ [cat_name]
      end)
      |> IO.inspect()

    {:noreply, new_state}
  end

  def handle_call({:get_breed, breed}, _from, state) do
    reply = state[breed]
    {:reply, reply, state}
  end
end

# Mocktail.CatBreedServer.get_breed("Abyssinian")
