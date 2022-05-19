defmodule Mocktail.CatBreedServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(_state) do
    {:ok, %{}}
  end

  def handle_cast(:add_cat, %{breed: breed, cat_name: cat_name}, state) do
    new_state =
      state
      |> Map.update(breed, [], fn cats ->
        cats ++ cat_name
      end)

    {:noreply, new_state}
  end

  # def create_cat_map(%{temperment: temperments, cat_name: cat_name}) do
  #     temperments
  #     |> Enum.reduce(%{}, fn temperment, map ->
  #       map
  #       |> Map.merge(%{temperment => cat_name})
  #     end)
  # end
end
