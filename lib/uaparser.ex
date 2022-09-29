defmodule UAParserRS do
  use Rustler,
    otp_app: :uaparser_rs,
    crate: :uaparser_nif,
    mode: :release

  def add(_a, _b), do: nif()

  def load(), do: nif()

  def parse(user_agent) when is_binary(user_agent), do: nif()
  
  def parse_all(user_agents) when is_list(user_agents), do: nif()

  defp nif(), do: :erlang.nif_error(:nif_not_loaded)
end
