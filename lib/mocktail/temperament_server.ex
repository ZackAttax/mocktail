defmodule Mocktail.TemperamentServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(_state) do
    {:ok, %{}}
  end

  def handle_cast(:add_cat, %{temperament: temperament, cat_name: cat_name}, state) do
    new_state =
      state
      |> Map.update(temperament, [], fn cats ->
        cats ++ cat_name
      end)

    {:noreply, new_state}
  end
end
