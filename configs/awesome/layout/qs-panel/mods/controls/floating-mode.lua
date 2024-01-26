local button_template = require("layout.qs-panel.mods.controls.base")

local floating_mode = button_template({
  icon = "󰀿",
  name = "Modo flotante",
  on_fn = function()
    Awful.spawn("pamixer -m", false)
  end,
  off_fn = function()
    Awful.spawn("pamixer -u", false)
  end,
})

return floating_mode
