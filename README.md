
# Videologue

> is an Umbrella Phoenix project created following `Rumbl` project example flow from Book `Programming Phoenix >=1.4`

---

* to run on dev node with some data

```
git clone https://github.com/abhishekkr/videologue_umbrella.git
pushd videologue_umbrella

mix deps.get
pushd apps/videologue_web/assets && npm install && popd

mix ecto.drop
mix ecto.create
mix ecto.migrate
mix run apps/videologue/priv/repo/seeds_test_data.exs
mix run apps/videologue/priv/repo/seeds.exs
mix phx.server
```

---
