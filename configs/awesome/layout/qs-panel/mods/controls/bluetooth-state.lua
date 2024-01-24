local button_template = require("layout.qs-panel.mods.controls.base")

local bluetooth = button_template({
  icon = "󰂯",
  name = "Bluetooth",
  on_fn = function()
    Awful.spawn("pamixer -m", false)
  end,
  off_fn = function()
    Awful.spawn("pamixer -u", false)
  end,
  settings = function ()
    Awful.spawn("blueman-manager", false)
  end
})

return bluetooth
