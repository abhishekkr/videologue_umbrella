defmodule Videologue.Multimedia.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Videologue.Multimedia.Permalink, autogenerate: true}
  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string

    has_many  :annotations, Videologue.Multimedia.Annotation
    belongs_to :user, Videologue.Accounts.User
    belongs_to :category, Videologue.Multimedia.Category

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
    |> validate_length(:description, min: 10)
    |> assoc_constraint(:category)
    |> slugify_title()
  end

  defp slugify_title(video) do
    case fetch_field(video, :title) do
      {x, nil} -> video
      {x, title} when {x, title} in [{:data, title}, {:changes, title}] ->
        put_change(video, :slug, slugify(title))
      :error -> video
    end
  end
  defp slugify(nil), do: raise "nil to slug"
  defp slugify(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^\w]+/u, "-")
    |> String.replace(~r/-+/u, "-")
  end
end
