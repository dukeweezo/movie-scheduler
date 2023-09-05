defmodule MovieScheduler.Repo.Migrations.CreateSchedules do
  use Ecto.Migration

  
  defmacrop add_hour_fields do


    for n <- 1..48 do
      quote do
        add String.to_atom(Integer.to_string(unquote(n))), :map, default: %{empty: true}
      end
    end
  end
  

"""
  defp default_hour_fields() do
    for n <- 1..48 do
      %{empty: true}
    end
  end

  """

  def change do
    create table(:schedules) do
      add :the_date, :date, null: false

      #add :grids, {:array, :map}, default: default_hour_fields()

      add_hour_fields()

      timestamps()
    end
  end
  
end
