defmodule UAParserTest do
  use ExUnit.Case
  doctest UAParser

  test "greets the world" do
    assert :world = UAParser.hello()
  end

  test "adding works" do
    assert 3 = UAParser.add(1, 2)
  end
  
  test "load works" do
    assert :ok = UAParser.load()
  end
  
  test "parse works" do
    UAParser.parse("foo")
  end
end
