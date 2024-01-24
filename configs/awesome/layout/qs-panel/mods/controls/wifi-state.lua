local button_template = require("layout.qs-panel.mods.controls.base")

local wifi = button_template({
  icon = "󰤢",
  name = "Internet",
  on_fn = function()
    Awful.spawn("pamixer -m", false)
  end,
  off_fn = function()
    Awful.spawn("pamixer -u", false)
  end,
})

return wifi
