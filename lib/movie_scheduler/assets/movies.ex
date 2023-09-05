defmodule MovieScheduler.Assets.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :description, :string
    field :title, :string
    field :image, :string
    field :duration, :integer

    timestamps()
  end

  @doc false
  def changeset(movies, attrs) do
    movies
    |> cast(attrs, [:title, :description, :image, :duration])
    |> validate_required([:title, :description, :image, :duration])
  end
end
