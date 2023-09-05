defmodule MovieScheduler.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :title, :string
      add :description, :text
      add :image, :string
      add :duration, :integer

      timestamps()
    end
  end
end
