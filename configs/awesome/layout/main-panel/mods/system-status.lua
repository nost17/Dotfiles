local dpi = Beautiful.xresources.apply_dpi

local battery_charging_icon = Wibox.widget({
  widget = Wibox.container.margin,
  -- right = dpi(-7),
  visible = false,
  {
    markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰉁"), Beautiful.yellow),
    font = Beautiful.font_icon .. "11",
    halign = "center",
    valign = "center",
    widget = Wibox.widget.textbox,
  },
})
local battery_bar = Wibox.widget({
  battery_charging_icon,
  value = 0,
  min_value = 0,
  max_value = 100,
  bg = Helpers.color.ldColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
  start_angle = math.pi * 1.5,
  rounded_edge = true,
  thickness = dpi(3),
  forced_width = dpi(28),
  forced_height = dpi(28),
  colors = {
    Beautiful.green,
  },
  widget = Wibox.container.arcchart,
})
battery_bar.value = tonumber(Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity"))

awesome.connect_signal("lib::battery", function(capacity, charging)
  battery_bar.value = capacity
  if charging then
    battery_charging_icon.visible = true
    battery_bar:set_colors({ Beautiful.green })
  else
    battery_charging_icon.visible = false
    if capacity < 25 then
      battery_bar:set_colors({ Beautiful.red })
    end
  end
end)

local system_status_widget = Wibox.widget({
  widget = Wibox.container.background,
  bg = Beautiful.widget_bg_alt,
  {
    widget = Wibox.container.margin,
    top = dpi(7),
    bottom = dpi(7),
    {
      layout = Wibox.layout.fixed.vertical,
      {
        layout = Wibox.container.place,
        {
          layout = Wibox.container.place,
          halign = "center",
          valign = "center",
          battery_bar,
        },
      },
    },
  },
})

return system_status_widget
