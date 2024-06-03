local dpi = Beautiful.xresources.apply_dpi
local charging_icon = Wibox.widget({
  markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰉁"), Beautiful.yellow),
  font = Beautiful.font_icon .. "13",
  halign = "center",
  valign = "center",
  visible = false,
  widget = Wibox.widget.textbox,
})
local battery_bar = Wibox.widget({
  max_value = 100,
  value = 12,
  forced_height = dpi(18),
  forced_width = dpi(32),
  paddings = dpi(2),
  border_width = 1.5,
  border_color = Beautiful.fg_normal,
  color = Beautiful.green,
  background_color = Beautiful.transparent,
  bar_shape = Helpers.shape.rrect(Beautiful.small_radius),
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  widget = Wibox.widget.progressbar,
})
local battery_label = Wibox.widget({
  text = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity") .. "%",
  font = Beautiful.font_text .. "Medium 14",
  halign = "center",
  valign = "center",
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
return Wibox.widget({
  layout = Wibox.container.place,
  halign = "center",
  battery,
})
