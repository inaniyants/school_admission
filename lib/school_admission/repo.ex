defmodule SchoolAdmission.Repo do
  use Ecto.Repo,
    otp_app: :school_admission,
    adapter: Ecto.Adapters.Postgres
end
