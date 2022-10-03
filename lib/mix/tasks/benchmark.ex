defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  alias UAParserRS
  alias UAInspector

  @shortdoc "Runs a simple benchmark"
  def run(_) do
    # add_benchee()
    uaparser_benchee()
    # simple_bench()
  end

  defp add_benchee() do
    Benchee.run(%{
      "add_ex" => fn ->
        Enum.map(
          Enum.zip(0..9999, 0..9999),
          fn {a, b} -> a + b end
        )
      end,
      "add_rs" => fn ->
        Enum.map(
          Enum.zip(0..9999, 0..9999),
          fn {a, b} -> UAParserRS.add(a, b) end
        )
      end
    })
  end

  defp uaparser_benchee() do
    user_agents =
      File.read!("./test/resources/useragents.csv")
      |> String.split("\n")

    UAParserRS.load()

    Benchee.run(%{
      "ua_parser_beam_community_parse_single" => fn ->
        Enum.map(
          user_agents,
          &UAParser.parse(&1)
        )
      end,
      "uaparser_rs_parse_single" => fn ->
        Enum.map(
          user_agents,
          &UAParserRS.parse(&1)
        )
      end,
      "ua_inspector_parse_single" => fn ->
        Enum.map(
          user_agents,
          &UAInspector.parse(&1)
        )
      end,
      "uaparser_rs_parse_all" => fn ->
        UAParserRS.parse_all(user_agents)
      end
    })
  end

  defp simple_bench() do
    user_agents =
      File.read!("./test/resources/useragents.csv")
      |> String.split("\n")

    IO.puts("==== UAInspector Single ====")

    :timer.tc(fn ->
      Enum.each(1..15, fn _ ->
        user_agents
        |> Enum.map(fn ua ->
          UAInspector.parse(ua)
        end)
      end)
    end)
    |> print_time

    IO.puts("\n==== UAParserRS Single ====")

    :timer.tc(fn ->
      Enum.each(1..15, fn _ ->
        user_agents
        |> Enum.map(fn ua ->
          UAParserRS.parse(ua)
        end)
      end)
    end)
    |> print_time

    IO.puts("\n==== UAParserRS Batch ====")

    :timer.tc(fn ->
      Enum.each(1..15, fn _ ->
        UAParserRS.parse_all(user_agents)
      end)
    end)
    |> print_time
  end

  defp print_time({microseconds, :ok}) do
    IO.puts("Seconds taken: #{microseconds / 1_000_000}")
  end
end
