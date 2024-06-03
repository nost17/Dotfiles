local dpi = Beautiful.xresources.apply_dpi

local volume_btn = require("layout.qs-panel.mods.controls.muted-state")
local dnd_btn = require("layout.qs-panel.mods.controls.dnd-state")
local night_light_btn = require("layout.qs-panel.mods.controls.night-light")
local dark_mode_btn = require("layout.qs-panel.mods.controls.dark-mode")
local wifi_btn = require("layout.qs-panel.mods.controls.wifi-state")
local bluetooth_btn = require("layout.qs-panel.mods.controls.bluetooth-state")
local floating_btn = require("layout.qs-panel.mods.controls.floating-mode")
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
  },
  {
    widget = Wibox.container.background,
    -- bg = Beautiful.quicksettings_widgets_bg,
    -- shape = Beautiful.quicksettings_widgets_shape,
    {
      widget = Wibox.container.margin,
      -- margins = dpi(10),
      {
        layout = Wibox.layout.flex.horizontal,
        spacing = dpi(10),
        dark_mode_btn,
        floating_btn,
        require("layout.qs-panel.mods.controls.base")({
          icon = "󰃽",
          name = "Grabar",
          type = "simple",
          on_fn = function() end,
          off_fn = function() end,
        }),
        dnd_btn,
        night_light_btn,
      },
    },
  },
})

return controls
