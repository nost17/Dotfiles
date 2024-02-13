local dpi = Beautiful.xresources.apply_dpi
local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local volume_icon = Wibox.widget({
	markup = Helpers.text.colorize_text("󰕾", Beautiful.fg_normal .. "8F"),
	font = Beautiful.font_icon .. "38",
	halign = "center",
	valign = "center",
	widget = Wibox.widget.textbox,
})
local volume_bar = Wibox.widget({
	volume_icon,
	value = 0,
	min_value = 0,
	max_value = 100,
	bg = Beautiful.widget_bg_alt,
	start_angle = math.pi * 1.5,
	-- rounded_edge = true,
	colors = {
		Beautiful.blue,
	},
	widget = Wibox.container.arcchart,
})
local wdg = Wibox({
	bg = Beautiful.bg_normal,
	width = dpi(130),
	height = dpi(130),
	visible = false,
	ontop = true,
	screen = screen.primary,
	-- border_width = dpi(3),
	border_color = Beautiful.widget_bg_alt,
})
wdg.x = (screen_width / 2) - (wdg.width / 2)
wdg.y = screen_height - (wdg.height * 1.75)
local wdg_timer = Gears.timer({
	timeout = 0.8,
	autostart = false,
	single_shot = true,
	callback = function()
		wdg.visible = false
	end,
})
wdg:setup({
	{
		volume_bar,
		margins = dpi(15),
		widget = Wibox.container.margin,
	},
	layout = Wibox.container.place,
	halign = "center",
	valign = "center",
})

awesome.connect_signal("lib::volume", function(volume, muted)
	volume_bar.value = volume
end)

awesome.connect_signal("popup::volume:show", function()
	wdg.visible = true
	wdg_timer:again()
end)
