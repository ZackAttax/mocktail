# Mocktail

**Description**
This is a learning excercise to practice what I have learned in Elixir using Gen Servers Producers, Producer/Consumers, and Consumers
with an external API. Using these tools the aim is to download pictures of smart active cats!

The app is given a [list of breeds](lib/mocktail/breed_list.ex) 

The [producer](lib/mocktail/producer.ex) pulls from this list and passes them to the producer_consumer

The [producer_sonsumer](lib/mocktail/producer_consumer.ex) then filters the cats. We only want pictures of cats with
an energy level greater than 5 and adaptability of greater than 2



and different types of temperaments.

The breeds are then filtered by temperament based on info from the external API

If the breed falls within the temperment attribute it downloads a picture of the cat.

You then have a collection of cat pics with the desired temperment!

**Instructions**
I use asdf to manage my versions of Elixir and Erlang(among others) https://asdf-vm.com/guide/getting-started.html
Install Erlang 25.2.1          
Install Elixir 1.14

clone the repo from Github
get an api key from https://thecatapi.com/#pricing and place it in the catapi repo
run `mix deps.get`

start the app with `API_KEY=(your api key here) iex -S mix`


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mocktail](https://hexdocs.pm/mocktail).

 breed = "Bambino"
 Mocktail.get_breed(breed)