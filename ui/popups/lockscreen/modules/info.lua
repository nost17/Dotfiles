local wibox = Wibox
local gshape = Gears.shape
local beautiful = Beautiful
local dpi = beautiful.xresources.apply_dpi

return wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	spacing = beautiful.widget_spacing * 1.5,
	{
		widget = wibox.container.place,
		halign = "center",
		valign = "center",
		content_fill_vertical = true,
		fill_vertical = true,
		forced_height = dpi(34),
		forced_width = dpi(34),
		{
			widget = wibox.container.background,
			shape = gshape.circle,
			border_width = 1,
			border_color = beautiful.neutral[100],

			{
				widget = wibox.widget.imagebox,
				image = Beautiful.user_icon,
				halign = "center",
				valign = "center",
			},
		}
	},
	{
		widget = wibox.container.place,
		valign = "center",
		halign = "left",
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(-3),
			{
				widget = wibox.widget.textbox,
				text = User.info.user,
				font = beautiful.font_bold_m,
			},
			{
				widget = wibox.widget.textbox,
				opacity = 0.8,
				text = User.info.github,
				font = beautiful.font_reg_s,
			}
		}
	}
})
