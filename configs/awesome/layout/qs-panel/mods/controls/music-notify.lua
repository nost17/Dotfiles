local button_template = require("layout.qs-panel.mods.controls.base")

local music_notify_state = button_template({
  icon = "󰎇",
  name = "Avisos de música",
  on_by_default = User.config.music_notify,
  on_fn = function()
    User.config.music_notify = true
  end,
  off_fn = function()
    User.config.music_notify = false
  end,
})

return music_notify_state
