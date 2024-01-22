local dpi = Beautiful.xresources.apply_dpi
Beautiful.quicksettings_ctrl_btn_shape = Helpers.shape.rrect(Beautiful.small_radius)
Beautiful.quicksettings_ctrl_btn_bg = Beautiful.quicksettings_widgets_bg
Beautiful.quicksettings_ctrl_btn_spacing = dpi(5)

local volume_btn = require("layout.qs-panel.mods.controls.muted-state")
local dnd_btn = require("layout.qs-panel.mods.controls.dnd-state")
local night_light_btn = require("layout.qs-panel.mods.controls.night-light")
local music_notify_btn = require("layout.qs-panel.mods.controls.music-notify")

return Wibox.widget({
  layout = Wibox.layout.flex.vertical,
  spacing = dpi(10),
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    volume_btn,
    dnd_btn,
  },
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    night_light_btn,
    music_notify_btn
  },
  -- {
  --   layout = Wibox.layout.flex.horizontal,
  --   spacing = dpi(10),
  -- },
})
