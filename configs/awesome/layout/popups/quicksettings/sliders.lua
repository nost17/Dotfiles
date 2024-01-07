local volume_value
local color = Helpers.color.ldColor(Beautiful.accent_color, User.config.dark_mode and 1 or -35)

local function mkbar(bar, icon)
	return Wibox.widget({
		layout = Wibox.container.place,
		forced_height = Dpi(30),
		{
			{
				{
					icon,
					bar,
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
			shape = Helpers.shape.rrect(Beautiful.small_radius),
			widget = Wibox.container.background,
		},
	})
end

local volume_bar = Wibox.widget({
	bar_height = Dpi(6),
	bar_active_color = color,
	bar_color = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
	minimum = 0,
	maximum = 100,
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

-- BRIGHTNESS

local bright_bar = Wibox.widget({
	bar_height = Dpi(6),
	bar_active_color = color,
  value = tonumber(Helpers.misc.getCmdOut("xbacklight -get")),
	bar_color = Helpers.color.LDColor(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
	minimum = 1,
	maximum = 100,
	handle_color = color,
	handle_border_color = Beautiful.widget_bg_alt,
	handle_border_width = Dpi(3),
	handle_width = Dpi(16),
	bar_shape = Gears.shape.rounded_bar,
	handle_shape = Gears.shape.circle,
	widget = Wibox.widget.slider,
})
local bright_icon = Wibox.widget({
	text = "󰃠",
	font = Beautiful.font_icon .. "12",
	halign = "center",
	widget = Wibox.widget.textbox,
})

awesome.connect_signal("system::volume", function(volume, _)
	volume_value = volume
	timer:again()
end)
volume_bar:connect_signal("property::value", function(_, new_value)
	Awful.spawn("pamixer --set-volume " .. new_value, false)
end)

bright_bar:connect_signal("property::value", function(_, new_value)
	Awful.spawn("xbacklight " .. new_value, false)
end)

return Wibox.widget {
  mkbar(volume_bar, volume_icon),
  mkbar(bright_bar, bright_icon),
  spacing = Dpi(8),
  layout = Wibox.layout.fixed.vertical,
}
