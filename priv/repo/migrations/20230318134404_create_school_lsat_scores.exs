defmodule SchoolAdmission.Repo.Migrations.CreateSchoolLsatScores do
  use Ecto.Migration

  def change do
    create table(:school_lsat_scores) do
      add(:year, :smallint, null: false)
      add :percentile_25, :smallint, null: false
      add :percentile_50, :smallint, null: false
      add :percentile_75, :smallint, null: false

      add :school_id, references(:schools, on_delete: :nothing, null: false)

      timestamps()
    end

    create index(:school_lsat_scores, [:school_id])
    create unique_index(:school_lsat_scores, [:school_id, :year])
  end
end
