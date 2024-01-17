local function mkbar(min)
	local bar = Wibox.widget({
		value = 10,
		id = "bar",
		-- bar_height = Dpi(30),
		bar_active_color = Helpers.color.LDColor(
			Beautiful.color_method,
			Beautiful.color_method_factor * 1.3,
			Beautiful.widget_bg_alt
		),
		bar_color = Beautiful.widget_bg_alt,
		minimum = min or 0,
		maximum = 100,
		handle_color = Helpers.color.LDColor(
			Beautiful.color_method,
			Beautiful.color_method_factor * 1.3,
			Beautiful.widget_bg_alt
		),
		handle_width = 2,
		handle_margins = 0,
		handle_border_width = 0,
		handle_shape = Gears.shape.circle,
		bar_shape = Helpers.shape.rrect(Beautiful.small_radius),
		widget = Wibox.widget.slider,
	})
	return bar
end

local function set_icon_in_bar(icon, color, bar)
	local wdg = Wibox.widget({
		layout = Wibox.container.place,
		-- forced_height = Dpi(40),
		{
			widget = Wibox.container.background,
			{
				layout = Wibox.layout.stack,
				bar,
				{
					widget = Wibox.widget.textbox,
					markup = Helpers.text.colorize_text(
						icon,
						Helpers.color.LDColor("lighten", Beautiful.color_method_factor * 1.3, color)
					),
					valign = "center",
					halign = "center",
					font = Beautiful.font_icon .. "14",
				},
			},
		},
	})
	return wdg
end

-- local volume_bar = set_icon_in_bar("󰕾", Beautiful.magenta)
local volume_bar = mkbar()
local brightness_bar = mkbar(1)

local volume_value
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

brightness_bar:connect_signal("property::value", function(_, new_value)
	Awful.spawn("xbacklight " .. new_value, false)
end)

return Wibox.widget({
	layout = Wibox.layout.flex.vertical,
	spacing = Dpi(5),
	set_icon_in_bar("󰕾", Beautiful.magenta, volume_bar),
	set_icon_in_bar("󰃠", Beautiful.yellow, brightness_bar),
})
