defmodule MocktailTest do
  use ExUnit.Case
  doctest Mocktail

  test "greets the world" do
    assert Mocktail.hello() == :world
  end
end
