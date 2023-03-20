defmodule SchoolAdmissionWeb.SchoolLive.Scores do
  use SchoolAdmissionWeb, :live_view

  alias SchoolAdmission.Schools

  import SchoolAdmissionWeb.SchoolLive.Components

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:active_tab, :scores)
      |> assign(:school, nil)
      |> assign(:year, "all")
      |> assign(:test_type, "LSAT")
      |> assign(:school_scores, nil)
      |> assign(:scores_metadata, %{})
      |> stream(:schools, Schools.list_schools())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Law schools admittance scores median")
  end

  @impl true
  def handle_event("school_selected", %{"value" => school_id}, socket) do
    school = school_id |> maybe_sanitize_value |> maybe_get_school

    socket =
      socket
      |> assign(:school, school)
      |> apply_filters()

    {:noreply, socket}
  end

  @impl true
  def handle_event("test_type_selected", %{"value" => test_type}, socket) do
    socket =
      socket
      |> assign(:test_type, maybe_sanitize_value(test_type))
      |> apply_filters()

    {:noreply, socket}
  end

  @impl true
  def handle_event("year_selected", %{"value" => year}, socket) do
    socket =
      socket
      |> assign(:year, maybe_sanitize_value(year))
      |> apply_filters()

    {:noreply, socket}
  end

  defp apply_filters(%{assigns: %{school: school, test_type: test_type, year: year}} = socket)
       when not is_nil(school) and not is_nil(test_type) do
    years =
      if year == "all" || is_nil(year) do
        []
      else
        [year]
      end

    school_scores = get_school_scores(test_type, school, years)
    scores_metadata = calculate_scores_metadata(school_scores)

    assign(socket, school_scores: school_scores, scores_metadata: scores_metadata)
  end

  defp apply_filters(socket) do
    socket
    |> assign(:school_scores, nil)
    |> assign(:scores_metadata, %{})
  end

  defp calculate_scores_metadata(scores) do
    last_index = length(scores) - 1

    scores
    |> Enum.sort(&(&1.percentile_50 >= &2.percentile_50))
    |> Enum.with_index()
    |> Enum.map(fn {score, index} ->
      {score.id,
       %{
         is_highest: index === 0,
         is_lowest: index === last_index,
         percentile_50: score.percentile_50,
         year: score.year
       }}
    end)
    |> Enum.into(%{})
  end

  def get_highest_score_metadata(scores_metadata) do
    scores_metadata
    |> Enum.find(fn {_score_id, metadata} -> metadata.is_highest end)
    |> elem(1)
  end

  def get_lowest_score_metadata(scores_metadata) do
    scores_metadata
    |> Enum.find(fn {_score_id, metadata} -> metadata.is_lowest end)
    |> elem(1)
  end

  defp get_school_scores("LSAT", school, years) do
    Schools.list_lsat_scores(school, years)
  end

  defp get_school_scores("GPA", school, years) do
    Schools.list_gpa_scores(school, years)
  end

  defp maybe_sanitize_value(""), do: nil

  defp maybe_sanitize_value(value), do: value

  defp maybe_get_school(nil), do: nil

  defp maybe_get_school(school_id) do
    Schools.get_school(school_id)
  end
end
