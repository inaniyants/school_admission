defmodule SchoolAdmission.Repo.Migrations.SeedSchoolScores do
  use Ecto.Migration

  import Ecto.SeedMigration

  alias SchoolAdmission.Schools
  alias SchoolAdmission.Schools.Datasource.SchoolScoresCsvParser

  seed_migration do
    case SchoolScoresCsvParser.execute() do
      {:ok, schools} ->
        schools |> Enum.map(&insert_school!/1)

      error ->
        raise "Error of parsing data for seed migration #{inspect(error)}"
    end
  end

  def down_implementation do
    IO.ANSI.format([:yellow, "Seed migration not reverted, clear tables manually"]) |> IO.puts()
  end

  defp insert_school!({_shool_name, school_data}) do
    Schools.create_school!(school_data)
  end

  defp insert_school!(school_data),
    do: raise(ArgumentError, message: "School data is wrong #{inspect(school_data)}")
end
