local core = require(... .. ".modules")
local wbutton = Utils.widgets.button

local notification_center = Wibox.widget({
	layout = Wibox.layout.fixed.vertical,
	spacing = Beautiful.widget_spacing,
	{
		layout = Wibox.layout.align.horizontal,
		{
			widget = Wibox.container.margin,
			left = 2,
			{
				widget = Wibox.widget.textbox,
				markup = Helpers.text.colorize_text(("Notificaciones"), Beautiful.primary[400]),
				font = Beautiful.font_med_l,
			},
		},
		nil,
		Wibox.widget({
			widget = wbutton.normal,
			padding = {
				left = Beautiful.widget_padding.outer,
				right = Beautiful.widget_padding.outer,
				top = Beautiful.widget_padding.inner * 0.75,
				bottom = Beautiful.widget_padding.inner * 0.75,
			},
			color = Beautiful.red[300],
			on_press = function()
				core:reset()
			end,
			{
				widget = Wibox.container.background,
				fg = Beautiful.widget_color[1],
				{
					widget = Wibox.widget.textbox,
					text = "limpiar",
					font = Beautiful.font_reg_s,
				}
			}
		}),
	},
	core.layout,
})

return notification_center
