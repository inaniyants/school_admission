defmodule SchoolAdmission.SchoolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SchoolAdmission.Schools` context.
  """

  @doc """
  Generate a school.
  """
  def school_fixture(attrs \\ %{}) do
    {:ok, school} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SchoolAdmission.Schools.create_school()

    school
  end
end
