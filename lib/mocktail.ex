defmodule Mocktail do
  alias Mocktail.CatBreedServer
  alias Mocktail.TemperamentServer

  @moduledoc """
  Documentation for `Mocktail`.

  get_breed/1 to get a list of cats of a particular breed
  get_temperament to get a list of cats with a particular temperament
  """
  @spec get_breed(string()) :: [string()]
  def get_breed(breed) do
    CatBreedServer.get(breed)
  end

  @spec get_temperament(string()) :: [string()]
  def get_temperament(temperament) do
    TemperamentServer.get(temperament)
  end

  def get_pics_of_breed(breed) do
    breed
    |> Mocktail.get_breed()
    |> get_pics()
  end

  def get_pics_of_temperament(temperament) do
    temperament
    |> get_temperament()
    |> get_pics()
  end

  def get_pics(cat) do
    cat
    |> Enum.map(fn cat ->
      cat
      |> get_pic_of()
    end)
  end

  def get_pic_of(cat) do
    "./cat_pics/#{cat}.jpeg"
    |> File.read()
    |> then(fn {_, resp} -> resp end)
  end
end
