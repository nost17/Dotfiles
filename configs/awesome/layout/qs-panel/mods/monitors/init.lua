local dpi = Beautiful.xresources.apply_dpi
local mkmonitor = require("layout.qs-panel.mods.monitors.base")
local function getPercentage(value, total)
  return (value / total) * 100 + 0.5
end

local disk_monitor = mkmonitor({
  icon = "󰆓",
  color = Beautiful.red,
  update_fn = function(self)
    awesome.connect_signal("lib:disk", function(disk)
      local partition = disk["/home"]
      self:set_value(partition.perc)
    end)
  end,
})
local cpu_monitor = mkmonitor({
  icon = "󰍛",
  color = Beautiful.blue,
  update_fn = function(self)
    awesome.connect_signal("lib::cpu", function(cpu_usage)
      self:set_value(cpu_usage)
    end)
  end,
})
local ram_monitor = mkmonitor({
  icon = "󰆼",
  color = Beautiful.magenta,
  update_fn = function(self)
    awesome.connect_signal("lib::ram", function(ram)
      self:set_value(getPercentage(ram.used, ram.total))
    end)
  end,
})
local temp_monitor = mkmonitor({
  icon = "󰔏",
  color = Beautiful.orange or Beautiful.yellow,
  update_fn = function(self)
    awesome.connect_signal("lib::temperature", function(temp)
      self:set_value(temp)
    end)
  end,
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
