defmodule CodezillaTest do
  use ExUnit.Case
  doctest Codezilla

  test "greets the world" do
    assert Codezilla.hello() == :world
  end
end
