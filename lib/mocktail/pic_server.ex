defmodule Mocktail.PicServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{}}
  end

  def get(cat_name) do
    GenServer.call(__MODULE__, {:get_pic , cat_name})
  end

  def handle_cast({:add_cat, %{pic: pic, cat_name: cat_name}}, state) do
    new_state =
      state
      |> Map.put(cat_name, pic)

      # new_state
      # |> Map.keys()
      # |> IO.inspect(label: "Cats with pictures:")

    {:noreply, new_state}
  end

  def handle_call({:get_pic, cat_name}, _from, state) do
    reply = state[cat_name]
    {:reply, reply, state}
  end
end

# Mocktail.PicServer.get_breed("Abyssinian")
