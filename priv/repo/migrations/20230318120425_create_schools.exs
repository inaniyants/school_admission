defmodule SchoolAdmission.Repo.Migrations.CreateSchools do
  use Ecto.Migration

  def change do
    create table(:schools) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:schools, [:name])
  end
end
