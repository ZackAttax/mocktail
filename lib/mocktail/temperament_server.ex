defmodule Mocktail.TemperamentServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{}}
  end

  @spec get(String.t()) :: list()
  def get(temperament) do
    GenServer.call(__MODULE__, {:get, temperament})
  end

  def handle_cast({:add_cat, %{temperament: temperament, cat_name: cat_name}}, state) do
    new_state =
      state
      |> Map.update(temperament, [cat_name], fn cats ->
        cats ++ [cat_name]
      end)

      state
      |> print_temperament_if_new(new_state, temperament)

    {:noreply, new_state}
  end

  def handle_call({:get, temperament}, _from, state) do
    reply = state[temperament]

    {:reply, reply, state}
  end

  defp print_temperament_if_new(state_keys, new_state, temperament) do
    unless state_keys |> Map.has_key?(temperament) do
      new_state
      |> Map.keys()
      |> IO.inspect(label: "Temperments Available:")
    end
  end
end
