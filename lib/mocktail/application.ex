defmodule Mocktail.Application do

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: CatFanciersRegistry},
      {DynamicSupervisor, name: Mocktail.CpiSupervisor, strategy: :one_for_one},
      {Mocktail.Producer, :ok},
      {Mocktail.ProducerConsumer, :ok},
      {Mocktail.Consumer, :ok},
      {Mocktail.TemperamentServer, :ok},
      {Mocktail.CatBreedServer, :ok},
      {Mocktail.PicServer, :ok}
    ]

    opts = [strategy: :one_for_one, name: Mocktail.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
