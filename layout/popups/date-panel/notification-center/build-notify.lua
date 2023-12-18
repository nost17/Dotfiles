local list_names = {
	"dunstify",
	"notify-send",
	"",
}
local colors = {
	["low"] = Beautiful.green,
	["normal"] = Beautiful.blue,
	["critical"] = Beautiful.red,
}
local function mkimagew(image, size)
	return image
		and Wibox.widget({
			{
				image = image,
				halign = "center",
				valign = "center",
				clip_shape = Helpers.shape.rrect(Dpi(3)),
				widget = Wibox.widget.imagebox,
			},
			strategy = "exact",
			height = size,
			width = size,
			widget = Wibox.container.constraint,
		})
end
local function mknotification(n)
	local accent_color = colors[n.urgency]
	local show_image = true
	for _, def_name in pairs(list_names) do
		if n.app_name == def_name then
			n.app_name = Naughty.config.defaults.app_name
		end
	end
	local app_icon_path = Helpers.misc.getIcon(n.app_name)
	local n_title = Wibox.widget.textbox()
	local n_message = Wibox.widget.textbox()
	local n_image = Wibox.widget({
		clip_shape = Beautiful.notification_icon_shape,
		valign = "start",
		halign = "center",
		widget = Wibox.widget.imagebox,
	})
	n_title:set_valign("top")
	n_message:set_valign("top")
	Helpers.text.set_markup(n_title, n.title, Beautiful.notification_fg, Beautiful.notification_font_title)
	Helpers.text.set_markup(n_message, n.message, Beautiful.notification_fg, Beautiful.notification_font_message)
	n_image:set_image(Gears.surface.load_silently(n.icon))
	local app_icon = mkimagew(app_icon_path, Dpi(16))
	local app_name = Wibox.widget({
		text = n.app_name:gsub("^%l", string.upper),
		font = Beautiful.notification_font_appname,
		halign = "center",
		valign = "center",
		widget = Wibox.widget.textbox,
	})
	if type(n.icon) ~= "userdata" then
		show_image = n.icon ~= app_icon_path
	end
	local n_appname = Wibox.widget({
		{
			{
				app_icon,
				app_name,
				spacing = Dpi(6),
				layout = Wibox.layout.fixed.horizontal,
			},
			nil,
			{
				{
					markup = Helpers.text.colorize_text("<b>" .. os.date("%H:%M") .. "</b>", accent_color),
					font = Beautiful.notification_font_hour,
					halign = "center",
					valign = "center",
					widget = Wibox.widget.textbox,
				},
				widget = Wibox.container.margin,
				-- bottom = 2,
			},
			layout = Wibox.layout.align.horizontal,
		},
		left = Dpi(3),
		widget = Wibox.container.margin,
	})
	return Wibox.widget({
		{
			{
				{
					n_appname,
					top = Dpi(6),
					left = Dpi(8),
					right = Dpi(8),
					widget = Wibox.container.margin,
				},
				{
					{
						{
							{
								show_image and n_image,
								strategy = "max",
								height = Dpi(34),
								widget = Wibox.container.constraint,
							},
							{
								{
									n_title,
									n_message,
									-- spacing = 2,
									layout = Wibox.layout.fixed.vertical,
								},
								top = Dpi(-2),
								layout = Wibox.container.margin,
							},
							spacing = Dpi(6),
							layout = Wibox.layout.fixed.horizontal,
						},
						left = Dpi(2),
						right = Dpi(2),
						layout = Wibox.container.margin,
					},
					left = Dpi(6),
					right = Dpi(6),
					bottom = Dpi(6),
					layout = Wibox.container.margin,
				},
				spacing = Dpi(6),
				layout = Wibox.layout.fixed.vertical,
			},
			margins = 0,
			-- margins = {
			-- 	top = 6,
			-- 	bottom = 8,
			-- 	right = 6,
			-- 	left = 6,
			-- },
			widget = Wibox.container.margin,
		},
		-- border_width = 2,
		-- border_color = Beautiful.black,
		shape = Helpers.shape.rrect(Beautiful.notification_border_radius),
		bg = Beautiful.widget_bg_alt,
		widget = Wibox.container.background,
	})
end
return mknotification
