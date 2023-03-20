defmodule SchoolAdmission.Schools.School do
  use Ecto.Schema
  import Ecto.Changeset

  alias SchoolAdmission.Schools.LsatScore
  alias SchoolAdmission.Schools.GpaScore
  alias SchoolAdmission.Schools.Rank

  schema "schools" do
    field :name, :string

    has_many :lsat_scores, LsatScore
    has_many :gpa_scores, GpaScore
    has_many :ranks, Rank

    timestamps()
  end

  @required_fields [
    :name
  ]

  @optional_fields []

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:lsat_scores)
    |> cast_assoc(:gpa_scores)
    |> cast_assoc(:ranks)
    |> validate_required(@required_fields)
    |> unique_constraint([:name])
  end
end
