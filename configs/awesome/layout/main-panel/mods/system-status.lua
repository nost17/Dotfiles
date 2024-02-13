local dpi = Beautiful.xresources.apply_dpi

-- [[ BATTERY ]]
local battery_charging_icon = Wibox.widget({
  widget = Wibox.widget.textbox,
  markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰉁"), Beautiful.yellow),
  font = Beautiful.font_icon .. "11",
  halign = "center",
  valign = "center",
  visible = false,
})
local battery_bar = Wibox.widget({
  widget = Wibox.container.arcchart,
  value = 0,
  min_value = 0,
  max_value = 100,
  bg = Helpers.color.ldColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
  start_angle = math.pi * 1.5,
  rounded_edge = false,
  thickness = dpi(2),
  forced_width = dpi(28),
  forced_height = dpi(28),
  colors = {
    Beautiful.green,
  },
  battery_charging_icon,
})
battery_bar.value = tonumber(Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity"))

awesome.connect_signal("lib::battery", function(capacity, charging)
  if capacity ~= battery_bar.value then
    battery_bar.value = capacity
    battery_charging_icon.visible = charging
    if not charging and capacity < 25 then
      battery_bar:set_colors({ Beautiful.red })
    else
      battery_bar:set_colors({ Beautiful.green })
    end
  end
end)

-- [[ VOLUME ]]
local volume_muted_icon = Wibox.widget({
  widget = Wibox.widget.textbox,
  markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰝟"), Beautiful.magenta),
  font = Beautiful.font_icon .. "13",
  halign = "center",
  valign = "center",
  visible = false,
})

local volume_bar = Wibox.widget({
  widget = Wibox.container.arcchart,
  value = 0,
  min_value = 0,
  max_value = 100,
  bg = Helpers.color.ldColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
  start_angle = math.pi * 1.5,
  rounded_edge = false,
  thickness = dpi(2),
  forced_width = dpi(28),
  forced_height = dpi(28),
  colors = {
    Beautiful.magenta,
  },
  volume_muted_icon,
})
awesome.connect_signal("lib::volume", function(volume, muted)
  volume_bar.value = volume
  volume_muted_icon.visible = muted
end)

-- [[ SYSTEM STATUS ]]
local system_status_widget = Wibox.widget({
  layout = Wibox.layout.fixed.vertical,
  spacing = dpi(10),
  {
    {
      base_size = 24,
      horizontal = false,
      widget = Wibox.widget.systray,
    },
    valign = "center",
    halign = "center",
    layout = Wibox.container.place,
  },
  {
    widget = Wibox.container.background,
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    bg = Beautiful.widget_bg_alt,
    {
      widget = Wibox.container.margin,
      top = dpi(7),
      bottom = dpi(7),
      {
        layout = Wibox.layout.fixed.vertical,
        spacing = dpi(10),
        volume_bar,
        battery_bar,
      },
    },
  },
})

return system_status_widget
