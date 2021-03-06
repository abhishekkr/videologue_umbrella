# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Videologue.Repo.insert!(%Videologue.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Videologue.Multimedia

defmodule Seeds.Multimedia.Category do
  def add_default do
    for category <- ~w(erlang elixir phoenix) do
      Multimedia.create_category!(category)
    end
  end
end

defmodule Seeds.Accounts.User do
  def add_backend do
    for user <- ~w(wolfram) do
      {:ok, _} = Videologue.Accounts.create_user(%{
        name: String.capitalize(user), username: user
      })
    end
  end
end

Seeds.Multimedia.Category.add_default()
Seeds.Accounts.User.add_backend()
