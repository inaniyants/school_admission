defmodule SchoolAdmissionWeb.SchoolLive.Match do
  use SchoolAdmissionWeb, :live_view

  alias SchoolAdmission.Schools
  alias SchoolAdmission.Schools.School
  alias SchoolAdmission.Schools.Rank

  @max_schools 12

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:active_tab, :match)
      |> assign(:year, 2022)
      |> assign(:test_type, "LSAT")
      |> assign(:score, nil)
      |> assign(:schools, nil)
      |> assign(:upper_deviation, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("match", %{"score" => score, "test_type" => test_type, "year" => year}, socket)
      when byte_size(score) > 0 and byte_size(test_type) > 0 and byte_size(year) > 0 do
    {schools, deviation, score} =
      case test_type do
        "LSAT" ->
          {Schools.match_by_lsat_score(score, year, @max_schools), Decimal.new(2),
           Decimal.new(score)}

        "GPA" ->
          {Schools.match_by_gpa_score(score, year, @max_schools), Decimal.new("0.15"),
           Decimal.new(score) |> Decimal.round(2)}
      end
      |> IO.inspect(label: "matched")

    socket =
      socket
      |> assign(:score, score)
      |> assign(:test_type, test_type)
      |> assign(:year, year)
      |> assign(:schools, schools)
      |> assign(:upper_deviation, Decimal.add(score, deviation))

    {:noreply, socket}
  end

  @impl true
  def handle_event("match", _patams, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("test_type_change", %{"test_type" => test_type}, socket) do
    socket =
      socket
      |> assign(:score, nil)
      |> assign(:schools, nil)
      |> assign(:upper_deviation, nil)
      |> assign(test_type: test_type)

    {:noreply, socket}
  end

  def get_matched_score("LSAT", school) do
    school.lsat_scores |> List.first()
  end

  def get_matched_score("GPA", school) do
    school.gpa_scores |> List.first()
  end

  def get_school_rank_string(%School{ranks: [%Rank{top: top, bottom: bottom}]})
      when not is_nil(top) do
    [bottom, top]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("-")
  end

  def get_school_rank_string(%School{}) do
    "Unranked"
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Law schools admittance scores matching"))
  end
end
