defmodule MovieScheduler.Accounts.Schedule.Macros do
  alias MovieScheduler.Types.Grid

  # Used to generate correct fields such as "1" => %{}
  # corresponding with each grid.
  defmacro add_hour_fields_to_schema do
    for n <- 1..48 do
      quote do
        field String.to_atom(Integer.to_string(unquote(n))), :map
      end
    end
  end
end

defmodule MovieScheduler.Accounts.Schedule do
  use Ecto.Schema
  import Ecto.Changeset
  require __MODULE__.Macros

  schema "schedules" do
    field :the_date, :date

    __MODULE__.Macros.add_hour_fields_to_schema()

    timestamps()
  end

  @doc false
  def changeset(schedule, attrs) do
    number_fields = for n <- 1..48, do: :"#{n}"
    fields = [:the_date] ++ for n <- 1..48, do: :"#{n}"

    schedule
    |> cast(attrs, fields)
    |> validate_required([:the_date])
  end
end
