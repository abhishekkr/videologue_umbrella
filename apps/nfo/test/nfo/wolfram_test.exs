defmodule NfoTest.WolframTest do
  use ExUnit.Case, async: true

  test "makes request for recorded results, then terminates" do
    assert "2" = Nfo.compute("1 + 1", []) |> hd() |> fn res -> res.text end.()
  end

  test "makes unrecorded request for empty results, then terminates" do
    assert [] = Nfo.compute("1 + 2", [])
  end
end
