defmodule SchoolAdmission.Schools.Datasource.SchoolScoresCsvParser do
  @initial_data_csv "/priv/repo/seeds/school_scores.csv"

  require Logger

  @spec execute ::
          {:error,
           {:parsing_error, %{:__exception__ => true, :__struct__ => atom, optional(atom) => any}}}
          | {:ok, any}
  def execute() do
    try do
      path = Application.app_dir(:school_admission, @initial_data_csv)

      {:ok, parse_csv(path)}
    rescue
      error ->
        {:error, {:parsing_error, error}}
    end
  end

  defp parse_csv(path) do
    File.stream!(path)
    |> CSV.decode!(field_transform: &String.trim/1, headers: true)
    |> Enum.reduce(%{}, &hydrate_data/2)
  end

  defp hydrate_data(%{"School" => school_name} = row_data, acc) when byte_size(school_name) > 0 do
    case acc do
      %{^school_name => school_data} ->
        Map.put(acc, school_name, populate_school_from_row(school_data, row_data))

      _ ->
        school_data =
          populate_school_from_row(
            %{
              "name" => school_name,
              "lsat_scores" => [],
              "gpa_scores" => [],
              "ranks" => []
            },
            row_data
          )

        acc
        |> Map.put_new(school_name, school_data)
    end
  end

  defp hydrate_data(_row_data, acc) do
    Logger.warn("[#{__MODULE__} skip row data for empty school name]")
    acc
  end

  defp populate_school_from_row(
         %{
           "lsat_scores" => lsat_scores,
           "gpa_scores" => gpa_scores,
           "ranks" => ranks
         } = school_data,
         row_data
       ) do
    %{
      school_data
      | "lsat_scores" => lsat_scores ++ [parse_lsat_score(row_data)],
        "gpa_scores" => gpa_scores ++ [parse_gpa_score(row_data)],
        "ranks" => ranks ++ [parse_rank(row_data)]
    }
  end

  defp parse_lsat_score(
         %{
           "First Year Class" => year,
           "L25" => percentile_25,
           "L50" => percentile_50,
           "L75" => percentile_75
         } = _row_data
       ) do
    %{
      "year" => year,
      "percentile_25" => percentile_25,
      "percentile_50" => percentile_50,
      "percentile_75" => percentile_75
    }
  end

  defp parse_lsat_score(row_data),
    do: raise("[#{__MODULE__}] lsat_score csv parsing error for row: #{inspect(row_data)}")

  defp parse_gpa_score(
         %{
           "First Year Class" => year,
           "G25" => percentile_25,
           "G50" => percentile_50,
           "G75" => percentile_75
         } = _row_data
       ) do
    %{
      "year" => year,
      "percentile_25" => percentile_25,
      "percentile_50" => percentile_50,
      "percentile_75" => percentile_75
    }
  end

  defp parse_gpa_score(row_data),
    do: raise("[#{__MODULE__}] gpa_score csv parsing error for row: #{inspect(row_data)}")

  defp parse_rank(%{"First Year Class" => year, "Rank" => rank} = _row_data) do
    {top, bottom} =
      case String.split(rank, "-") do
        [top, bottom] when byte_size(top) > 0 and byte_size(bottom) > 0 ->
          {top, bottom}

        ["Unranked"] ->
          {nil, nil}

        [top] when byte_size(top) > 0 ->
          {top, nil}

        _ ->
          {nil, nil}
      end

    %{
      "year" => year,
      "top" => top,
      "bottom" => bottom
    }
  end

  defp parse_rank(row_data),
    do: raise("[#{__MODULE__}] rank csv parsing error for row: #{inspect(row_data)}")
end
