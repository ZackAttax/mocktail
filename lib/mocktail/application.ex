defmodule Mocktail.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Mocktail.Worker.start_link(arg)
      # {Mocktail.Worker, arg}
      {Registry, keys: :unique, name: CatFanciersRegistry},
      {DynamicSupervisor, name: Mocktail.CpiSupervisor, strategy: :one_for_one},
      {Mocktail.Producer, :ok},
      {Mocktail.ProducerConsumer, :ok},
      {Mocktail.Consumer, :ok},
      {Mocktail.TemperamentServer, :ok},
      {Mocktail.CatBreedServer, :ok}
      # %{
      #   id: 1,
      #   start: {Mocktail.Consumer, :start_link, [[]]}
      # },
      # %{
      #   id: 2,
      #   start: {Mocktail.Consumer, :start_link, [[]]}
      # }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mocktail.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
