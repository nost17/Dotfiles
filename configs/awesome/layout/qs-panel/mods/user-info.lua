----------------------
-- BATTERY WIDGET
----------------------

local dpi = Beautiful.xresources.apply_dpi
local charging_icon = Wibox.widget({
  markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰉁"), Beautiful.yellow),
  font = Beautiful.font_icon .. "12",
  halign = "center",
  valign = "center",
  visible = false,
  widget = Wibox.widget.textbox,
})
local battery_bar = Wibox.widget({
  max_value = 100,
  value = 12,
  forced_height = dpi(16),
  forced_width = dpi(30),
  paddings = dpi(2),
  border_width = 1.5,
  border_color = Beautiful.fg_normal,
  color = Beautiful.green,
  background_color = Beautiful.transparent,
  bar_shape = Helpers.shape.rrect(Beautiful.small_radius),
  shape = Helpers.shape.rrect(Beautiful.medium_radius),
  widget = Wibox.widget.progressbar,
})
local battery_label = Wibox.widget({
  text = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity") .. "%",
  font = Beautiful.font_text .. "Medium 12",
  halign = "center",
  widget = Wibox.widget.textbox,
})

battery_bar.value = tonumber(Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity"))

awesome.connect_signal("lib::battery", function(capacity, charging)
  battery_label:set_text(tostring(capacity) .. "%")
  battery_bar.value = capacity
  if charging then
    charging_icon.visible = true
  else
    charging_icon.visible = false
  end
end)

local battery = Wibox.widget({
  charging_icon,
  {
    {
      battery_bar,
      {
        {
          forced_height = dpi(9),
          forced_width = dpi(2),
          shape = Gears.shape.rounded_bar,
          bg = Beautiful.fg_normal,
          widget = Wibox.container.background,
        },
        layout = Wibox.container.place,
      },
      spacing = dpi(2),
      layout = Wibox.layout.fixed.horizontal,
    },
    layout = Wibox.container.place,
  },
  {
    widget = Wibox.container.margin,
    top = dpi(-2),
    battery_label,
  },
  spacing = dpi(8),
  layout = Wibox.layout.fixed.horizontal,
})

-- [[ SCREENSHOT ]]

-- function(self)
--   screenshot_settings.visible = not screenshot_settings.visible
--   if screenshot_settings.visible then
--     self:set_text("󰍟")
--   else
--     self:set_text("󰍝")
--   end
-- end

local show_sc_settings = require("utils.button").text.state({
  text = "󰄄󰍝",
  font = Beautiful.font_icon,
  shape = Beautiful.quicksettings_ctrl_btn_shape,
  bg_normal_on = Beautiful.accent_color,
  fg_normal_on = Beautiful.foreground_alt,
  paddings = {
    left = dpi(10),
    right = dpi(6),
    top = dpi(7),
    bottom = dpi(7),
  },
  size = 15,
  on_turn_on = function(self)
    self:set_text("󰄄󰍞")
    awesome.emit_signal("visible::quicksettings:sc", true)
  end,
  on_turn_off = function(self)
    self:set_text("󰄄󰍝")
    awesome.emit_signal("visible::quicksettings:sc", false)
  end,
})

awesome.connect_signal("visible::quicksettings", function(vis)
  if vis == false then
    show_sc_settings:set_text("󰄄󰍝")
    awesome.emit_signal("visible::quicksettings:sc", false)
    show_sc_settings:turn_off()
  end
end)

return Wibox.widget({
  layout = Wibox.layout.align.horizontal,
  battery,
  nil,
  show_sc_settings,
})
