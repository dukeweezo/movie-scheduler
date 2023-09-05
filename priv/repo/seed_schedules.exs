alias MovieScheduler.Repo
alias MovieScheduler.Accounts.Schedule
import MovieScheduler.SeedHelper
use Timex

# For use in dev.

Repo.delete_all Schedule

%Schedule{ the_date: Timex.today() }
|> Map.merge(default_hour_fields(1, %{length: 4, asset_id: 1}))
|> Map.merge(default_hour_fields(2, 4, %{}))
|> Map.merge(default_hour_fields(5, 48, %{length: 1, asset_id: nil}))
|> Repo.insert!

%Schedule{ the_date: Timex.shift(Timex.today(), days: 1) }
|> Map.merge(default_hour_fields())
|> Repo.insert!

%Schedule{ the_date: Timex.shift(Timex.today(), days: 2) }
|> Map.merge(default_hour_fields(1, %{length: 4, asset_id: 1}))
|> Map.merge(default_hour_fields(2, 4, %{}))
|> Map.merge(default_hour_fields(5, 48, %{length: 1, asset_id: nil}))
|> Repo.insert!

%Schedule{ the_date: Timex.shift(Timex.today(), days: 3) }
|> Map.merge(default_hour_fields())
|> Repo.insert!

%Schedule{ the_date: Timex.shift(Timex.today(), days: 4) }
|> Map.merge(default_hour_fields())
|> Repo.insert!
