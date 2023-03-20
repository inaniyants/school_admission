defmodule SchoolAdmission.Schools.Rank do
  use Ecto.Schema
  import Ecto.Changeset

  alias SchoolAdmission.Schools.School

  schema "school_ranks" do
    field :bottom, :integer
    field :top, :integer
    field :year, :integer

    belongs_to(:school, School)

    timestamps()
  end

  @required_fields [
    :year
  ]

  @optional_fields [
    :top,
    :bottom
  ]

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:school_id, :year])
  end
end
