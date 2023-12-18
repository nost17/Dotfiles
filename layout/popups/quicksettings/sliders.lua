local volume_value
local color = Helpers.color.ldColor(Beautiful.accent_color, User.config.dark_mode and 1 or -35)
local volume_bar = Wibox.widget({
	bar_height = Dpi(6),
	bar_active_color = color,
	bar_color = Beautiful.black,
	minimun = 0,
	maximun = 100,
	handle_color = color,
	handle_border_color = Beautiful.widget_bg_alt,
	handle_border_width = Dpi(3),
	handle_width = Dpi(16),
	bar_shape = Gears.shape.rounded_bar,
	handle_shape = Gears.shape.circle,
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
	forced_height = Dpi(30),
	{
		{
			{
				volume_icon,
				volume_bar,
				spacing = Dpi(6),
				layout = Wibox.layout.fixed.horizontal,
			},
			margins = {
				left = Dpi(12),
				right = Dpi(12),
				top = Dpi(8),
				bottom = Dpi(8),
			},
			widget = Wibox.container.margin,
		},
		bg = Beautiful.widget_bg_alt,
		shape = Helpers.shape.rrect(Dpi(8)),
		widget = Wibox.container.background,
	},
})
