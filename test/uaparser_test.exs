defmodule UAParserTest do
  use ExUnit.Case
  doctest UAParser

  setup do
    user_agents = File.stream!("./test/resources/useragents.csv")
    |> NimbleCSV.RFC4180.parse_stream(skip_headers: true)
    |> Enum.map(&Enum.at(&1, 0))

    %{user_agents: user_agents}
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
