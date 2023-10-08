local volume_value
local volume_bar = Wibox.widget({
	bar_height = 6,
	bar_active_color = Beautiful.blue,
	bar_color = Beautiful.widget_bg_alt,
	minimun = 0,
	maximun = 100,
	handle_color = Beautiful.blue,
	handle_border_color = Beautiful.widget_bg_color,
	handle_border_width = 4,
	handle_width = 16,
	widget = Wibox.widget.slider,
})
local volume_icon = Wibox.widget({
	text = "󰕾",
	font = Beautiful.font_icon .. "12",
	halign = "center",
	widget = Wibox.widget.textbox,
})
local timer = Gears.timer({
	timeout = 1,
	autostart = false,
	single_shot = true,
	callback = function()
		volume_bar.value = volume_value
	end,
})

awesome.connect_signal("system::volume", function(volume, _)
	volume_value = volume
	timer:again()
end)
volume_bar:connect_signal("property::value", function(_, new_value)
	Awful.spawn("pamixer --set-volume " .. new_value, false)
end)

return Wibox.widget({
	layout = Wibox.container.place,
	forced_height = 16,
	{
		volume_icon,
		volume_bar,
		spacing = 6,
		layout = Wibox.layout.fixed.horizontal,
	},
})
