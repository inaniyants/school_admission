defmodule SchoolAdmission.Repo.Migrations.CreateSchoolGpaScores do
  use Ecto.Migration

  def change do
    create table(:school_gpa_scores) do
      add :year, :smallint, null: false
      add :percentile_25, :decimal, precision: 3, scale: 2, null: false
      add :percentile_50, :decimal, precision: 3, scale: 2, null: false
      add :percentile_75, :decimal, precision: 3, scale: 2, null: false

      add :school_id, references(:schools, on_delete: :nothing, null: false)

      timestamps()
    end

    create index(:school_gpa_scores, [:school_id])
    create unique_index(:school_gpa_scores, [:school_id, :year])
  end
end
