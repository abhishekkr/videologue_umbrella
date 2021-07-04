defmodule Nfo.Test.HTTPClient do
  @wolfram_empty "<queryresult></queryresult>"
  @wolfram_1plus1_xml File.read!("test/fixtures/wolfram_1plus1.xml")

  def request(url) do
    cond do
      url |> to_string() |> String.contains?("1+%2B+1") -> {:ok, {[], [], @wolfram_1plus1_xml}}
      true -> {:ok, {[], [], @wolfram_empty}}
    end
  end
end
