local button_template = require("layout.qs-panel.mods.controls.base")

local dnd_state = button_template({
  icon = "󰍶",
  name = "No molestar",
  on_by_default = User.config.dnd_state,
  on_fn = function()
    Naughty.destroy_all_notifications(nil, 1)
    User.config.dnd_state = true
  end,
  off_fn = function()
    User.config.dnd_state = false
  end,
})

return dnd_state
