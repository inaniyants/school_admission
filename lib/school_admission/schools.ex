defmodule SchoolAdmission.Schools do
  @moduledoc """
  The Schools context.
  """

  import Ecto.Query, warn: false
  alias SchoolAdmission.Repo

  alias SchoolAdmission.Schools.School
  alias SchoolAdmission.Schools.LsatScore
  alias SchoolAdmission.Schools.GpaScore

  @doc """
  Returns the list of schools.

  ## Examples

      iex> list_schools()
      [%School{}, ...]

  """
  def list_schools do
    Repo.all(School)
  end

  @doc """
  Gets a single school.

  Raises `Ecto.NoResultsError` if the School does not exist.

  ## Examples

      iex> get_school!(123)
      %School{}

      iex> get_school!(456)
      ** (Ecto.NoResultsError)

  """
  def get_school!(id), do: Repo.get!(School, id)

  @doc """
  Gets a single school or returns nil.

  ## Examples

      iex> get_school(123)
      %School{}

      iex> get_school(456)
      nil

  """
  def get_school(id), do: Repo.get(School, id)

  @doc """
  Creates a school.

  ## Examples

      iex> create_school(%{field: value})
      {:ok, %School{}}

      iex> create_school(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_school(attrs \\ %{}) do
    %School{}
    |> School.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a school.

  Raises `Ecto.InvalidChangesetError` if the attrs are incorrect

  ## Examples

      iex> create_school!(%{field: value})
      %School{}

      iex> create_school!(%{field: bad_value})
      ** (Ecto.InvalidChangesetError)

  """
  def create_school!(attrs \\ %{}) do
    %School{}
    |> School.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a school.

  ## Examples

      iex> update_school(school, %{field: new_value})
      {:ok, %School{}}

      iex> update_school(school, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_school(%School{} = school, attrs) do
    school
    |> School.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a school.

  ## Examples

      iex> delete_school(school)
      {:ok, %School{}}

      iex> delete_school(school)
      {:error, %Ecto.Changeset{}}

  """
  def delete_school(%School{} = school) do
    Repo.delete(school)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking school changes.

  ## Examples

      iex> change_school(school)
      %Ecto.Changeset{data: %School{}}

  """
  def change_school(%School{} = school, attrs \\ %{}) do
    School.changeset(school, attrs)
  end

  def list_lsat_scores(%School{id: id}, years \\ []) do
    LsatScore
    |> where([score], score.school_id == ^id)
    |> maybe_add_year_cond(years)
    |> order_by([score], {:desc, score.year})
    |> Repo.all()
  end

  def list_gpa_scores(%School{id: id}, years \\ []) do
    GpaScore
    |> where([score], score.school_id == ^id)
    |> maybe_add_year_cond(years)
    |> order_by([score], {:desc, score.year})
    |> Repo.all()
  end

  def match_by_lsat_score(score, year, limit \\ 10) do
    School
    |> join(:inner, [s], score in assoc(s, :lsat_scores))
    |> join(:left, [s, score], rank in assoc(s, :ranks))
    |> where([s, score], score.year == ^year and score.percentile_50 <= ^score)
    |> where([s, score, rank], rank.year == ^year)
    |> order_by([s, score, rank], asc_nulls_last: rank.top, desc: score.percentile_50)
    |> limit(^limit)
    |> preload([s, score, rank], lsat_scores: score, ranks: rank)
    |> Repo.all()
  end

  def match_by_gpa_score(score, year, limit \\ 10) do
    School
    |> join(:inner, [s], score in assoc(s, :gpa_scores))
    |> join(:left, [s, score], rank in assoc(s, :ranks))
    |> where([s, score], score.year == ^year and score.percentile_50 <= ^score)
    |> where([s, score, rank], rank.year == ^year)
    |> order_by([s, score, rank], asc_nulls_last: rank.top, desc: score.percentile_50)
    |> limit(^limit)
    |> preload([s, score, rank], gpa_scores: score, ranks: rank)
    |> Repo.all()
  end

  defp maybe_add_year_cond(query, []), do: query

  defp maybe_add_year_cond(query, years) do
    query
    |> where([score], score.year in ^years)
  end
end
