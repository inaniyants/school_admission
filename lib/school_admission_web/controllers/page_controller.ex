defmodule SchoolAdmissionWeb.PageController do
  use SchoolAdmissionWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/schools/scores")
  end
end
