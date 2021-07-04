defmodule NfoTest do
  use ExUnit.Case
  doctest Nfo

  alias Nfo.Result

  defmodule TestBackend do
    def name, do: "TestBack"

    def compute("result", _opts), do: [%Result{backend: __MODULE__, text: "#"}]
    def compute("none", _opts), do: []
    def compute("timeout", _opts), do: Process.sleep(:infinity)
    def compute("boom", _opts), do: raise "boom!"
  end

  test "compute/2 with backend results" do
    assert [%Result{backend: TestBackend, text: "#"}] =
      Nfo.compute("result", backends: [TestBackend])
  end

  test "compute/2 with empty result" do
    assert [] = Nfo.compute("none", backends: [TestBackend])
  end

  test "compute/2 with timeout returns empty" do
    assert [] = Nfo.compute("timeout", backends: [TestBackend], timeout: 10)
  end

  @tag :capture_log
  test "compute/2 discards backend errors" do
    assert [] = Nfo.compute("boom", backends: [TestBackend])
  end
end
