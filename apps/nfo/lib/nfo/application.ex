defmodule Nfo.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Nfo.Cache,
      {Task.Supervisor, name: Nfo.TaskSupervisor},
    ]

    opts = [strategy: :one_for_one, name: Nfo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
