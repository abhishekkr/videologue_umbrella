defmodule Nfo.Backend do
  @callback name() :: String.t()

  @callback compute(query :: String.t(), opts :: Keyword.t()) :: [%Nfo.Result{}]
end
