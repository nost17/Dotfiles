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
	value = 40,
	forced_height = dpi(25),
	forced_width = dpi(70),
	paddings = 0,
	border_width = 0,
	border_color = Beautiful.fg_normal,
	color = Beautiful.cyan,
	background_color = Beautiful.cyan .. "4F",
	bar_shape = Gears.shape.rounded_bar,
	shape = Gears.shape.rounded_bar,
	widget = Wibox.widget.progressbar,
})

local battery_label = Wibox.widget({
	text = Helpers.getCmdOut("cat /sys/class/power_supply/BAT0/capacity") .. "%",
	font = Beautiful.font_text ..  "Regular 13",
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
	layout = Wibox.layout.fixed.horizontal,
	spacing = dpi(10),
	{
		widget = Wibox.widget.imagebox,
		image = Beautiful.user_icon,
		clip_shape = Gears.shape.circle,
		halign = "center",
		valign = "center",
		forced_height = dpi(35),
		forced_width = dpi(35),
	},
	{
		layout = Wibox.container.place,
		battery_bar,
	},
	battery_label,
	charging_icon,
})

return battery
