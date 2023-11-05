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
				clip_shape = Helpers.shape.rrect(3),
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
	if type(n.icon) ~= "userdata" then
		show_image = n.icon ~= Helpers.misc.getIcon(n.app_name)
	end
	local app_name = Wibox.widget({
		text = n.app_name:gsub("^%l", string.upper),
		font = Beautiful.notification_font_appname,
		halign = "center",
		valign = "center",
		widget = Wibox.widget.textbox,
	})
	local app_icon = mkimagew(Helpers.misc.getIcon(n.app_name), 18)
	local n_appname = Wibox.widget({
		{
			{
				{
					app_icon,
					left = app_icon and 4 or 0,
					bottom = 2,
					widget = Wibox.container.margin,
				},
				{
					app_name,
					left = app_icon and 4 or 6,
					bottom = 2,
					right = 7,
					widget = Wibox.container.margin,
				},
				layout = Wibox.layout.fixed.horizontal,
			},
			bg = Beautiful.black_alt,
			fg = Beautiful.fg_normal .. "CC",
			shape = Helpers.shape.prrect(10, nil, nil, true, nil),
			widget = Wibox.container.background,
		},
		nil,
		{
			{
				{
					markup = Helpers.text.colorize_text("<b>" .. os.date("%H:%M") .. "</b>", accent_color),
					font = Beautiful.notification_font_appname,
					halign = "center",
					valign = "center",
					widget = Wibox.widget.textbox,
				},
				widget = Wibox.container.margin,
				left = 7,
				bottom = 2,
				right = 4,
			},
			bg = Beautiful.black_alt,
			fg = Beautiful.fg_normal .. "CC",
			shape = Helpers.shape.prrect(10, nil, nil, nil, true),
			widget = Wibox.container.background,
		},
		forced_height = 22,
		layout = Wibox.layout.align.horizontal,
	})
	return Wibox.widget({
		{
			{
				{
					n_appname,
					{
						{
							{
								{
									show_image and n_image,
									strategy = "max",
									height = 34,
									widget = Wibox.container.constraint,
								},
								{
									{
										n_title,
										n_message,
										-- spacing = 2,
										layout = Wibox.layout.fixed.vertical,
									},
									top = -2,
									layout = Wibox.container.margin,
								},
								spacing = 6,
								layout = Wibox.layout.fixed.horizontal,
							},
							spacing = 6,
							layout = Wibox.layout.fixed.vertical,
						},
						margins = 6,
						layout = Wibox.container.margin,
					},
					layout = Wibox.layout.fixed.vertical,
				},
				shape = Helpers.shape.rrect(Beautiful.notification_border_radius),
				bg = Beautiful.notification_bg,
				widget = Wibox.container.background,
			},
			margins = 2,
			widget = Wibox.container.margin,
		},
		shape = Helpers.shape.rrect(Beautiful.notification_border_radius),
		bg = Beautiful.black_alt,
		widget = Wibox.container.background,
	})
end
return mknotification
