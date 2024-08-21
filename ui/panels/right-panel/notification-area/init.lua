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
				font = Beautiful.font_name .. "Medium 14",
			},
		},
		nil,
		Wibox.widget({
			widget = wbutton.normal,
			padding = {
				top = Beautiful.widget_padding.inner * 0.75,
				bottom = Beautiful.widget_padding.inner * 0.75,
				left = Beautiful.widget_padding.inner,
				right = Beautiful.widget_padding.inner,
			},
			color = Beautiful.red[300],
			on_press = function()
				core:reset()
			end,
      {
        widget = Utils.widgets.icon,
        icon = {
          path = Beautiful.icons .. "others/clear.svg"
        },
        color = Beautiful.neutral[900],
        size = 16,
      }			
		}),
	},
	core.layout,
})

return notification_center
