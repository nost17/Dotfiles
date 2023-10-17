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
	Helpers.text.set_markup(n_title, n.title, Beautiful.green, Beautiful.notification_font_title)
	Helpers.text.set_markup(n_message, n.message, Beautiful.red, Beautiful.notification_font_message)
	local n_image = require("layout.notifications.image")(n)
	if type(n.icon) ~= "userdata" then
		show_image = n.icon ~= Helpers.misc.getIcon(n.app_name)
	end
	local app_name = Wibox.widget({
		text = n.app_name:gsub("^%l", string.upper),
		-- text = type(n.icon) ~= "userdata" and n.icon or type(n.icon),
		font = Beautiful.notification_font_appname,
		halign = "center",
		valign = "center",
		widget = Wibox.widget.textbox,
	})
	local app_icon = mkimagew(Helpers.misc.getIcon(n.app_name), 18)
	local awesome_icon = mkimagew(Gears.color.recolor_image(Beautiful.awesome_icon, accent_color), 18)
	local n_appname = Wibox.widget({
		{
			{
				{
					app_icon,
					left = app_icon and 4 or 0,
					widget = Wibox.container.margin,
				},
				{
					app_name,
					left = app_icon and 4 or 6,
					right = 7,
					widget = Wibox.container.margin,
				},
				layout = Wibox.layout.fixed.horizontal,
			},
			forced_height = 26,
			bg = Beautiful.black_alt,
			fg = Beautiful.fg_normal .. "CC",
			shape = Helpers.shape.prrect(10, nil, nil, true, nil),
			widget = Wibox.container.background,
		},
		nil,
		{
			{
				awesome_icon,
				widget = Wibox.container.margin,
				left = 7,
				bottom = 2,
				right = 4,
			},
			forced_height = 26,
			bg = Beautiful.black_alt,
			fg = Beautiful.fg_normal .. "CC",
			shape = Helpers.shape.prrect(10, nil, nil, nil, true),
			widget = Wibox.container.background,
		},
		layout = Wibox.layout.align.horizontal,
	})
	local actions = Wibox.widget({
		notification = n,
		base_layout = Wibox.widget({
			spacing = 4,
			layout = Wibox.layout.flex.horizontal,
		}),
		widget_template = {
			{
				{
					{
						id = "text_role",
						valign = "center",
						halign = "center",
						font = Beautiful.notification_font_actions,
						widget = Wibox.widget.textbox,
					},
					left = 8,
					right = 8,
					widget = Wibox.container.margin,
				},
				widget = Wibox.container.place,
			},
			forced_height = 26,
			-- forced_width = 70,
			widget = Wibox.container.background,
			create_callback = function(self, _, _, _)
				Helpers.ui.add_hover(
					self,
					Beautiful.widget_bg_color,
					Beautiful.fg_normal,
					Beautiful.accent_color,
					Beautiful.foreground_alt
				)
			end,
		},
		style = {
			underline_normal = false,
			underline_selected = true,
		},
		widget = Naughty.list.actions,
	})
	return Wibox.widget({
		{
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
										height = Beautiful.notification_icon_height,
										widget = Wibox.container.constraint,
									},
									{
										-- Helpers.ui.vertical_pad(2),
										n_title,
										n_message,
										-- spacing = 2,
										layout = Wibox.layout.fixed.vertical,
									},
									spacing = 6,
									layout = Wibox.layout.fixed.horizontal,
								},
								(n.actions and #n.actions > 0) and actions,
								spacing = 6,
								layout = Wibox.layout.fixed.vertical,
							},
							margins = 6,
							layout = Wibox.container.margin,
						},
						layout = Wibox.layout.fixed.vertical,
					},
					margins = 0,
					widget = Wibox.container.margin,
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
