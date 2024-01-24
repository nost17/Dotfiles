local button_template = require("layout.qs-panel.mods.controls.base")

-- 󰄀 󰄄 󰄅
local screenshot = button_template({
  icon = "󰄀",
  name = "Captura de pantalla",
  state_label = false,
  on_release = function()
    Awful.spawn("pamixer -t", false)
  end,
  settings = function()
    Naughty.notify{
      title = "xd"
    }
  end,
})


return screenshot
