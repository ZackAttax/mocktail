defmodule Mocktail.TemperamentServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{}}
  end

  @spec get(string()) :: list()
  def get(temperament) do
    GenServer.call(__MODULE__, {:get, temperament})
  end

  def handle_cast({:add_cat, %{temperament: temperament, cat_name: cat_name}}, state) do
    new_state =
      state
      |> Map.update(temperament, [cat_name], fn cats ->
        cats ++ [cat_name]
      end)
      |> IO.inspect()

    {:noreply, new_state}
  end

  def handle_call({:get, temperament}, _from, state) do
    reply = state[temperament]

    {:reply, reply, state}
  end
end

#  Mocktail.TemperamentServer.get("Loving")
