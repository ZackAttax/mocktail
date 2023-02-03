defmodule Mocktail.CpiServer do
  @moduledoc """
  This is a GenServer to make a calls the external API
  https://thecatapi.com/
  """
  use GenServer, restart: :temporary
  alias Mocktail.Producer

  def start_link(breed) do
    GenServer.start_link(__MODULE__, %{breed: breed})
  end

  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state, {:continue, :start_fetch}}
  end

  def via_tuple(breed) do
    {:via, Registry, {CatFanciersRegistry, breed}}
  end

  @spec handle_continue({:start_fetch}, %{:breed => any, optional(any) => any}) ::
          {:stop, :normal, any}
  def handle_continue(:start_fetch, %{breed: breed} = state) do
    get_cat_breed(breed)
    |> handle_response(state)
  end

  def handle_response(resp, state) do
    GenStage.cast(Producer, {:add_breed, resp})
    {:stop, :normal, state}
  end

  def get_cat_breed(breed) do
    Dummyio.get_breeds(breed)
  end

  def terminate(_, _), do: nil
end
