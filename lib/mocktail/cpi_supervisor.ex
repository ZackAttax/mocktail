defmodule Mocktail.CpiSupervisor do
  @moduledoc """
  """
  use DynamicSupervisor
  alias Mocktail.CpiServer

  def start_link(state) do
    DynamicSupervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec fetch_breed(any) :: :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def fetch_breed(state) do
    DynamicSupervisor.start_child(__MODULE__, {CpiServer, state})
  end

  # def temperment_gen_server(temperment) do
  #   DynamicSupervisor.start_child(__MODULE__, {TempermentServer, state})
  # end

  # def breed_gen_server(breed) do
  #   DynamicSupervisor.start_child(__MODULE__, {BreedServer, state})
  # end
end
