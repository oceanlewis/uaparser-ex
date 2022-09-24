defmodule UAParser do
  use Rustler,
    otp_app: :uaparser,
    crate: :uaparser_nif

  def hello do
    :world
  end

  def add(_a, _b), do: err()

  def load(), do: err()

  def parse(_user_agent), do: err()

  defp err(), do: :erlang.nif_error(:nif_not_loaded)
end
