defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  alias UAParser
  alias UAInspector

  @shortdoc "Runs a simple benchmark"
  def run(_) do
    user_agents =
      File.read!("./test/resources/useragents.csv")
      |> String.split("\n")
      |> Enum.map(&String.replace(&1, "\"", ""))

    IO.puts("==== Benchee BEGIN ====")
    UAParser.load()

    Benchee.run(%{
      # "add_ex" => fn ->
      #   Enum.map(
      #     Enum.zip(0..9999, 0..9999),
      #     fn {a, b} -> a + b end
      #   )
      # end,
      # "add_rs" => fn ->
      #   Enum.map(
      #     Enum.zip(0..9999, 0..9999),
      #     fn {a, b} -> UAParser.add(a, b) end
      #   )
      # end,
      "beam_community_ua_parser" => fn ->
        Enum.map(user_agents, &UAParser.parse(&1))
      end,
      "uaparser_ex_parse_single" => fn ->
        Enum.map(user_agents, &UAParser.parse(&1))
      end,
      "ua_inspector_parse_single" => fn ->
        Enum.map(user_agents, &UAInspector.parse(&1))
      end,
      # "uaparser_ex_parse_all" => fn ->
      #   UAParser.parse_all(user_agents)
      # end
    })

    # IO.puts("==== Benchee END ====")

    # IO.puts("\n==== Simple Iteration BEGIN ====")

    # IO.puts("==== Simple Iteration UAInspector Single ====")

    # :timer.tc(fn ->
    #   Enum.each(1..15, fn _ ->
    #     user_agents
    #     |> Enum.map(fn ua ->
    #       UAInspector.parse(ua)
    #     end)
    #   end)
    # end)
    # |> print_time

    # IO.puts("\n==== Simple Iteration UAParser Single ====")

    # :timer.tc(fn ->
    #   Enum.each(1..15, fn _ ->
    #     user_agents
    #     |> Enum.map(fn ua ->
    #       UAParser.parse(ua)
    #     end)
    #   end)
    # end)
    # |> print_time

    # IO.puts("\n==== Simple Iteration UAParser Batch ====")

    # :timer.tc(fn ->
    #   Enum.each(1..15, fn _ ->
    #     UAParser.parse_all(user_agents)
    #   end)
    # end)
    # |> print_time

    # IO.puts("\n==== Simple Iteration END ====")
  end

  defp print_time({microseconds, :ok}) do
    IO.puts("Seconds taken: #{microseconds / 1_000_000}")
  end
end
