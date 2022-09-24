defmodule UAParser do
  use Rustler,
    otp_app: :uaparser,
    crate: :uaparser

  def hello do
    :world
  end

  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  def load(), do: :erlang.nif_error(:nif_not_loaded)

  def parse(user_agent) when is_binary(user_agent), do: :erlang.nif_error(:nif_not_loaded)
end
