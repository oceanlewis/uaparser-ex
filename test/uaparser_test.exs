defmodule UAParserRSTest do
  use ExUnit.Case
  doctest UAParserRS

  setup do
    user_agents =
      File.read!("./test/resources/useragents.csv")
      |> String.split("\n")

    %{user_agents: user_agents}
  end

  test "adding works" do
    assert 3 = UAParserRS.add(1, 2)
  end

  test "load works" do
    assert :ok = UAParserRS.load()
  end

  test "parse works" do
    UAParserRS.parse(
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1a2) Gecko/20060512 BonEcho/2.0a2"
    )
  end
end
