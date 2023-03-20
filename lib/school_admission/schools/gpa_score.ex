defmodule SchoolAdmission.Schools.GpaScore do
  use Ecto.Schema
  import Ecto.Changeset

  alias SchoolAdmission.Schools.School

  schema "school_gpa_scores" do
    field :percentile_25, :decimal
    field :percentile_50, :decimal
    field :percentile_75, :decimal
    field :year, :integer

    belongs_to(:school, School)

    timestamps()
  end

  @required_fields [
    :year,
    :percentile_25,
    :percentile_50,
    :percentile_75
  ]

  @optional_fields []

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:school_id, :year])
  end
end
