local button_template = require("layout.qs-panel.mods.controls.base")

local music_notify_state = button_template({
  icon = "󰎇",
  name = "Sinfonia",
  settings = function()
    Awful.spawn("kitty -o confirm_os_window_close=0 --class 'ncmpcpppad' -e ncmpcpp")
  end,
  on_by_default = User.config.music_notify,
  on_fn = function()
    User.config.music_notify = true
  end,
  off_fn = function()
    User.config.music_notify = false
  end,
})

return music_notify_state
