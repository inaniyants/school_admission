defmodule SchoolAdmission.Repo.Migrations.CreateSchoolRanks do
  use Ecto.Migration

  def change do
    create table(:school_ranks) do
      add :year, :smallint, null: false
      add :top, :smallint
      add :bottom, :smallint

      add :school_id, references(:schools, on_delete: :nothing, null: false)

      timestamps()
    end

    create index(:school_ranks, [:school_id])
    create unique_index(:school_ranks, [:school_id, :year])
  end
end
