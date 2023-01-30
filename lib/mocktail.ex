defmodule Mocktail do
  alias Mocktail.CatBreedServer
  alias Mocktail.TemperamentServer
  alias Mocktail.PicServer

  @moduledoc """
  Documentation for `Mocktail`.

  get_breed/1 to get a list of cats of a particular breed
  get_temperament/1 to get a list of cats with a particular temperament
  """
  @spec get_breed(String.t()) :: [String.t()]
  def get_breed(breed) do
    CatBreedServer.get(breed)
  end

  @spec get_temperament(String.t()) :: [String.t()]
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

  def get_pics(cats) do
    cats
    |> Enum.map(fn cat_name ->
      cat_name
      |> get_pic_of()
      |> save_cat(cat_name)
    end)
  end

  defp save_cat(pic, cat_name) do
    path = "./cat_pics/#{cat_name}.jpeg"
    File.write(path, pic)
  end

  def get_pic_of(cat_name) do
   PicServer.get(cat_name)
  end
end
