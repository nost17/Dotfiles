----------------------
-- BATTERY WIDGET
----------------------

local charging_icon = Wibox.widget({
	markup = Helpers.text.colorize_text(Helpers.text.escape_text("󰉁"), Beautiful.yellow),
	font = Beautiful.font_icon .. "10",
	halign = "center",
	valign = "center",
  visible = false,
	widget = Wibox.widget.textbox,
})
local battery_bar = Wibox.widget({
	charging_icon,
	value = 0,
	min_value = 0,
	max_value = 100,
	bg = Helpers.color.LDColor(
		Beautiful.color_method,
		Beautiful.color_method_factor * 1.4,
		Beautiful.widget_bg_alt
	),
  thickness = 3,
	start_angle = math.pi * 1.5,
	rounded_edge = true,
	colors = {
		Beautiful.blue,
	},
	widget = Wibox.container.arcchart,
})

battery_bar.value = tonumber(Helpers.misc.getCmdOut("cat /sys/class/power_supply/BAT0/capacity"))

return Wibox.widget({
  {
	battery_bar,
	reflection = {
    horizontal = true
  },
	widget = Wibox.container.mirror,
},
  widget = Wibox.container.margin,
  top = 4.5,
  bottom = 4,
})
