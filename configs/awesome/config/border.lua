local getName = require("utils.modules.get_name")
local getIcon = require("utils.modules.get_icon")
Beautiful.titlebar_buttons_bg = Beautiful.widget_bg_alt
Beautiful.titlebar_buttons_bg_shape = Helpers.shape.rrect(Beautiful.small_radius * 0.8)

client.connect_signal("request::titlebars", function(c)
	local buttons = Gears.table.join({
		Awful.button({}, 1, function()
			c:activate({ context = "titlebar", action = "mouse_move" })
		end),
		Awful.button({}, 3, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	})
	local titlebar = Awful.titlebar(c, {
		size = Beautiful.titlebar_size,
		enable_tooltip = false,
		position = "top",
		bg = Beautiful.titlebar_bg_normal,
		fg = Beautiful.fg_normal,
	})
	titlebar.widget = {
		widget = Wibox.container.margin,
		margins = Dpi(5),
		{
			layout = Wibox.layout.align.horizontal,
			{
				widget = Wibox.container.margin,
				left = Dpi(4),
				{
					layout = Wibox.layout.fixed.horizontal,
					spacing = Dpi(7),
          buttons = buttons,
					{
						widget = Wibox.widget.imagebox,
						image = getIcon({
							client = c,
							icon_size = 48,
							-- try_fallback = true,
							-- name_fallback = "default-application",
						}),
						forced_height = Dpi(26),
						forced_width = Dpi(26),
						halign = "center",
						valign = "center",
					},
					{
						widget = Wibox.widget.textbox,
						visible = false,
						text = getName({ client = c, try_fallback = true, name_fallback = "default-application" }):gsub(
							"^%l",
							string.upper
						),
						halign = "left",
						font = Beautiful.font_text .. "Medium 12",
					},
				},
			},
      {
        widget = Wibox.container.background,
        buttons = buttons,
      },
			{
				widget = Wibox.container.background,
				forced_height = Dpi(30),
				bg = Beautiful.titlebar_buttons_bg,
				shape = Beautiful.titlebar_buttons_bg_shape,
				{
					widget = Wibox.container.margin,
					margins = Dpi(5),
					{
						layout = Wibox.layout.fixed.horizontal,
						spacing = Dpi(3),
						-- lol,
						Awful.titlebar.widget.minimizebutton(c),
						Awful.titlebar.widget.maximizedbutton(c),
						Awful.titlebar.widget.closebutton(c),
					},
				},
			},
		},
	}
end)

client.connect_signal("manage", function (c)
    c.shape = Helpers.shape.rrect(Beautiful.small_radius)
end)
