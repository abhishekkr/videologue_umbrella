defmodule Nfo.Wolfram do
  import SweetXml

  alias Nfo.Result

  @behaviour Nfo.Backend

  @base "https://api.wolframalpha.com/v2/query"
  @xpath_pod_title "contains(@title, 'Result') or
    contains(@title, 'Definitions') or
    contains(@title, 'Value')"

  @impl true
  def name, do: "wolfram"

  @impl true
  def compute(query_str, _opts) do
    query_str
    |> fetch_xml()
    |> xpath(~x"/queryresult/pod[#{@xpath_pod_title}]/subpod/plaintext/text()")
    |> build_results()
  end

  defp tee(x) do
    IO.puts "#{inspect x}"
    x
  end

  defp build_results(nil), do: []
  defp build_results(answer) do
    [%Result{backend: __MODULE__, score: 95, text: to_string(answer)}]
  end

  defp fetch_xml(query) do
    {:ok, {_,_,body}} = query
                        |> url()
    |> tee()
                        |> String.to_charlist()
                        |> :httpc.request()
    body
  end

  defp url(input) do
    "#{@base}?" <>
      URI.encode_query(appid: id(), input: input, format: "plaintext")
  end

  defp id, do: Application.fetch_env!(:nfo, :wolfram)[:app_id]
end
