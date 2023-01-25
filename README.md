# Mocktail

**Description**
This is a learning excercise to practice what I have learned in Elixir using Gen Servers Producers, Producer/Consumers, and Consumers
with an external API.

The app is given a list of breeds and different types of temperments.

The breeds are then filtered by temp based on info from the external API

If the breed falls within the temperment attribute it downloads a picture of the cat.

You then have a collection of cat pics with the desired temperment!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mocktail` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mocktail, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mocktail](https://hexdocs.pm/mocktail).

