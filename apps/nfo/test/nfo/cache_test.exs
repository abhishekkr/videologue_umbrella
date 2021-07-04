defmodule NfoTest.CacheTest do
  use ExUnit.Case, async: true
  doctest Nfo.Cache

  alias Nfo.Cache
  @moduletag clear_interval: 100

  setup %{test: name, clear_interval: clear_interval} do
    {:ok, pid} = Cache.start_link(name: name, clear_interval: clear_interval)
    {:ok, name: name, pid: pid}
  end

  test "key value pairs can be put & get from cache", %{name: name} do
    assert :ok = Cache.put(name, :keyx, :valuex)
    assert :ok = Cache.put(name, :keyy, :valuey)

    assert Cache.get(name, :keyx) == {:ok, :valuex}
    assert Cache.get(name, :keyy) == {:ok, :valuey}
  end

  test "unfound entry returns error", %{name: name} do
    assert Cache.get(name, :neverset) == :error
  end

  @tag clear_interval: 50
  test "clears all entries after clear interval", %{name: name} do
    assert :ok = Cache.put(name, :keyx, :valuex)
    assert Cache.get(name, :keyx) == {:ok, :valuex}
    assert eventually(fn -> Cache.get(name, :keyx) == :error end)
  end

  @tag clear_interval: 50_000
  test "values are cleaned up on exit", %{name: name, pid: pid} do
    assert :ok = Cache.put(name, :keyx, :valuex)
    assert_shutdown(pid)
    {:ok, _cache} = Cache.start_link(name: name)
    assert Cache.get(name, :keyx) == :error
  end

  defp assert_shutdown(pid) do
    ref = Process.monitor(pid)
    Process.unlink(pid)
    Process.exit(pid, :kill)
    assert_receive {:DOWN, ^ref, :process, ^pid, :killed}
  end

  defp eventually(foo) do
    if foo.() do
      true
    else
      Process.sleep(10)
      eventually(foo)
    end
  end
end
