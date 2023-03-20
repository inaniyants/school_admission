defmodule SchoolAdmissionWeb.SchoolLive.Components do
  use SchoolAdmissionWeb, :html

  attr :name, :string, required: true, doc: "name of the select field"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :value, :any, default: nil

  attr :options, :list,
    required: true,
    doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"

  attr :label, :string, default: nil, doc: "label for the select field"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  def select2(assigns) do
    ~H"""
    <.simple_form
      for={%{}}
      id={"select_#{@name}_component"}
      as={:school_select}
      phx-hook="Select2Live"
      phx-update="ignore"
      data-event-name={@name <> "_selected"}
    >
      <.input
        type="select"
        name={@name}
        label={@label}
        options={@options}
        prompt={@prompt}
        value={@value}
        multiple={@multiple}
      />
    </.simple_form>
    """
  end
end
