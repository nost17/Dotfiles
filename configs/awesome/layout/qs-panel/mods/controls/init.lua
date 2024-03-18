local dpi = Beautiful.xresources.apply_dpi

local volume_btn = require("layout.qs-panel.mods.controls.muted-state")
local dnd_btn = require("layout.qs-panel.mods.controls.dnd-state")
local night_light_btn = require("layout.qs-panel.mods.controls.night-light")
local dark_mode_btn = require("layout.qs-panel.mods.controls.dark-mode")
local wifi_btn = require("layout.qs-panel.mods.controls.wifi-state")
local bluetooth_btn = require("layout.qs-panel.mods.controls.bluetooth-state")
local floating_btn = require("layout.qs-panel.mods.controls.floating-mode")
local screenshot_btn = require("layout.qs-panel.mods.controls.screenshots")
local music_notify_btn = require("layout.qs-panel.mods.controls.music-alert")

local controls = Wibox.widget({
  layout = Wibox.layout.fixed.vertical,
  spacing = dpi(10),
  {
    layout = Wibox.layout.flex.vertical,
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
      music_notify_btn,
    },
    {
      layout = Wibox.layout.flex.horizontal,
      spacing = dpi(10),
      dark_mode_btn,
      floating_btn,
    },
  },
  {
    layout = Wibox.layout.fixed.vertical,
    spacing = dpi(10),
    {
      layout = Wibox.layout.grid.horizontal,
      forced_num_rows = 1,
      vertical_homogeneous = false,
      vertical_expand = false,
      horizontal_homogeneous = true,
      spacing = dpi(10),
      screenshot_btn.button,
      require("layout.qs-panel.mods.controls.base")({
        icon = "󰃽",
        name = "Grabar",
        on_fn = function() end,
        off_fn = function() end,
      }),
      {
        layout = Wibox.layout.flex.horizontal,
        spacing = dpi(10),
        dnd_btn,
        night_light_btn,
      },
    },
  },
})

return controls
