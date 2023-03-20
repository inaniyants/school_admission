import jQuery from "jquery"
import select2 from "select2"

const Select2Live = {
  initSelect2() {
    select2()
    const hook = this
    const $select = jQuery(hook.el).find("select")

    $select.select2()
      .on("select2:select", (e) => hook.selected(hook, e))

    return $select
  },

  mounted() {
    this.initSelect2()
  },

  selected(hook, event) {
    const id = event.params.data.id
    const event_name = hook.el.dataset.eventName
    hook.pushEvent(event_name, { value: id })
  }
}

export default Select2Live