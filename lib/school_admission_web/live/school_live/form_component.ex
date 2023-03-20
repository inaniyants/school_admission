defmodule SchoolAdmissionWeb.SchoolLive.FormComponent do
  use SchoolAdmissionWeb, :live_component

  alias SchoolAdmission.Schools

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage school records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="school-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save School</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{school: school} = assigns, socket) do
    changeset = Schools.change_school(school)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"school" => school_params}, socket) do
    changeset =
      socket.assigns.school
      |> Schools.change_school(school_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"school" => school_params}, socket) do
    save_school(socket, socket.assigns.action, school_params)
  end

  defp save_school(socket, :edit, school_params) do
    case Schools.update_school(socket.assigns.school, school_params) do
      {:ok, school} ->
        notify_parent({:saved, school})

        {:noreply,
         socket
         |> put_flash(:info, "School updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_school(socket, :new, school_params) do
    case Schools.create_school(school_params) do
      {:ok, school} ->
        notify_parent({:saved, school})

        {:noreply,
         socket
         |> put_flash(:info, "School created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
