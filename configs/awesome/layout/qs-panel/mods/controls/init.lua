local dpi = Beautiful.xresources.apply_dpi

local monitors = require("layout.qs-panel.mods.monitors")
local volume_btn = require("layout.qs-panel.mods.controls.muted-state")
local dnd_btn = require("layout.qs-panel.mods.controls.dnd-state")
local night_light_btn = require("layout.qs-panel.mods.controls.night-light")
local music_notify_btn = require("layout.qs-panel.mods.controls.music-notify")
local dark_mode_btn = require("layout.qs-panel.mods.controls.dark-mode")
local wifi_btn = require("layout.qs-panel.mods.controls.wifi-state")
local bluetooth_btn = require("layout.qs-panel.mods.controls.bluetooth-state")
local floating_btn = require("layout.qs-panel.mods.controls.floating-mode")

return Wibox.widget({
  layout = Wibox.layout.fixed.vertical,
  spacing = dpi(10),
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    wifi_btn,
    volume_btn,
  },
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    bluetooth_btn,
    dnd_btn,
  },
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    {
      layout = Wibox.layout.flex.vertical,
      spacing = dpi(10),
      {
        layout = Wibox.layout.flex.horizontal,
        spacing = dpi(10),
        dark_mode_btn,
        floating_btn,
      },
      {
        layout = Wibox.layout.flex.horizontal,
        spacing = dpi(10),
        music_notify_btn,
        night_light_btn,
      },
    },
    monitors,
  },
  -- screenshot_btn,
})
