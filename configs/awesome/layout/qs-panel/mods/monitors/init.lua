local dpi = Beautiful.xresources.apply_dpi
local mkmonitor = require("layout.qs-panel.mods.monitors.base")

local disk_monitor = mkmonitor({
  icon = "󰆓",
  color = Beautiful.red,
})
local cpu_monitor = mkmonitor({
  icon = "󰍛",
  color = Beautiful.blue,
})
local ram_monitor = mkmonitor({
  icon = "󰆼",
  color = Beautiful.magenta,
})
local temp_monitor = mkmonitor({
  icon = "󰔏",
  color = Beautiful.orange or Beautiful.yellow,
})

return Wibox.widget({
  layout = Wibox.layout.flex.vertical,
  spacing = dpi(10),
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    ram_monitor,
    temp_monitor,
  },
  {
    layout = Wibox.layout.flex.horizontal,
    spacing = dpi(10),
    disk_monitor,
    cpu_monitor,
  },
})
