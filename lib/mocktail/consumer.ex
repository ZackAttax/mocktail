defmodule Mocktail.Consumer do
  use GenStage
  alias Mocktail.Name
  alias Mocktail.TemperamentServer
  alias Mocktail.CatBreedServer

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [{Mocktail.ProducerConsumer, max_demand: 3, min_demand: 1}]}
  end

  def handle_events(events, _from, state) do
    for cat <- events do
      cat
      |> deal_with_cat()
    end

    {:noreply, [], state}
  end

  defp deal_with_cat(cat) do
    %{
      cat_name: Name.generate(cat["name"]),
      temperaments: handle_temperaments(cat),
      breed: cat["name"],
      id: cat["reference_image_id"]
    }
    |> get_cat_lady_pic()
    |> send_to_temperament_gen_server()
    |> send_to_breed_gen_server()
  end

  def handle_temperaments(cat) do
    cat["temperament"]
    |> String.split(",")
    |> Enum.map(fn temperments ->
      temperments
      |> String.trim()
    end)
  end

  defp get_cat_lady_pic(%{id: id, cat_name: cat_name} = ctx) do
    url = "https://cdn2.thecatapi.com/images/#{id}.jpg"

    %HTTPoison.Response{body: body} = HTTPoison.get!(url)

    body
    |> save_cat(cat_name)

    ctx
  end

  defp save_cat(pic, name) do
    path = "./cat_pics/#{name}.jpeg"
    File.write(path, pic)
  end

  defp send_to_temperament_gen_server(%{temperaments: temperaments, cat_name: cat_name} = ctx) do
    temperaments
    |> Enum.each(fn temperament ->
      GenServer.cast(
        TemperamentServer,
        {:add_cat, %{temperament: temperament, cat_name: cat_name}}
      )
    end)

    ctx
  end

  def send_to_breed_gen_server(%{breed: breed, cat_name: cat_name} = ctx) do
    GenServer.cast(
      CatBreedServer,
      {:add_cat, %{breed: breed, cat_name: cat_name}}
    )

    ctx
  end
end
