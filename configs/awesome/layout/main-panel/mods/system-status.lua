local dpi = Beautiful.xresources.apply_dpi

local battery_charging_icon = Wibox.widget({
  widget = Wibox.container.margin,
  right = dpi(-7),
  visible = false,
  {
    markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰉁"), Beautiful.yellow),
    font = Beautiful.font_icon .. "12",
    halign = "center",
    valign = "center",
    widget = Wibox.widget.textbox,
  },
})
local battery_bar = Wibox.widget({
  max_value = 100,
  value = 10,
  forced_height = dpi(16),
  forced_width = dpi(24),
  paddings = dpi(2),
  border_width = 1.5,
  border_color = Beautiful.fg_normal,
  color = Beautiful.green,
  background_color = Beautiful.transparent,
  bar_shape = Helpers.shape.rrect(dpi(0)),
  shape = Helpers.shape.rrect(dpi(3)),
  widget = Wibox.widget.progressbar,
})
battery_bar.value = tonumber(Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity"))

awesome.connect_signal("awesome::battery", function(capacity, charging)
  battery_bar.value = capacity
  if charging then
    battery_charging_icon.visible = true
  else
    battery_charging_icon.visible = false
  end
end)

local battery = Wibox.widget({
  layout = Wibox.container.place,
  {
    direction = "east",
    widget = Wibox.container.rotate,
    {
      layout = Wibox.layout.fixed.horizontal,
      spacing = dpi(2),
      battery_bar,
      {
        layout = Wibox.container.place,
        {
          widget = Wibox.container.background,
          forced_height = dpi(7),
          forced_width = dpi(2),
          shape = Gears.shape.rounded_bar,
          bg = Beautiful.fg_normal,
        },
      },
    },
  },
})

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
          layout = Wibox.layout.fixed.horizontal,
          battery,
          battery_charging_icon,
        },
      },
    },
  },
})

return system_status_widget
