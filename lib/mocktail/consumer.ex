defmodule Mocktail.Consumer do
  use GenStage
  alias Mocktail.Name

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
        {:add_cat, %{temperament: temperament, cat_name: [cat_name]}}
      )
    end)

    ctx
  end
end

# %HTTPoison.Response{body: body} = HTTPoison.get!("https://cdn2.thecatapi.com/images/JAx-08Y0n.jpg")
# (gen_stage 1.0.0) lib/gen_stage.ex:2395: GenStage.consumer_dispatch/6
# Last message: {:"$gen_consumer", {#PID<0.330.0>, #Reference<0.1925616772.2345140238.83866>}, [%{"vetstreet_url" => "http://www.vetstreet.com/cats/abyssinian", "hypoallergenic" => 0, "id" => "abys", "short_legs" => 0, "hairless" => 0, "rex" => 0, "weight" => %{"imperial" => "7  -  10", "metric" => "3 - 5"}, "cfa_url" => "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx", "lap" => 1, "shedding_level" => 2, "vocalisation" => 1, "affection_level" => 5, "origin" => "Egypt", "grooming" => 1, "temperament" => "Active, Energetic, Independent, Intelligent, Gentle", "adaptability" => 5, "suppressed_tail" => 0, "rare" => 0, "vcahospitals_url" => "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian", "natural" => 1, "country_code" => "EG", "stranger_friendly" => 5, "reference_image_id" => "0XYvRd7oD", "intelligence" => 5, "child_friendly" => 3, "country_codes" => "EG", "wikipedia_url" => "https://en.wikipedia.org/wiki/Abyssinian_(cat)", "energy_level" => 5, "description" => "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.", "dog_friendly" => 4, "alt_names" => "", "social_needs" => 5, "health_issues" => 2, "experimental" => 0, "name" => "Abyssinian", "indoor" => 0, "life_span" => "14 - 15"}]}
# State: :state
