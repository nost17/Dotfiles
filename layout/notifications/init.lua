Naughty.config.defaults = {
	position = "top_right",
	timeout = 6,
	app_name = "AwesomeWM",
}
Naughty.connect_signal("request::icon", function(n, context, hints)
	if context ~= "app_icon" then
		hints.app_icon = n.app_name
		-- return
	end
	local path = Helpers.misc.getIcon(hints.app_icon)
	if path then
		n.icon = path
	end
end)
Naughty.connect_signal("request::action_icon", function(a, _, hints)
	a.icon = require("menubar").utils.lookup_icon(hints.id)
end)
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
	local n_title = require("layout.notifications.title")(n)
	local n_message = require("layout.notifications.message")(n)
	local n_image = require("layout.notifications.image")(n)
	local app_icon = mkimagew(Helpers.misc.getIcon(n.app_name), 18)
	local app_name = Wibox.widget({
		text = n.app_name:gsub("^%l", string.upper),
		font = Beautiful.notification_font_appname,
		halign = "center",
		valign = "center",
		widget = Wibox.widget.textbox,
	})
	if type(n.icon) ~= "userdata" then
		show_image = n.icon ~= Helpers.misc.getIcon(n.app_name)
	end
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
	local notify = Naughty.layout.box({
		notification = n,
		type = "notification",
		cursor = "hand1",
		bg = Beautiful.notification_border_color,
		-- filter = function(nn) return Naughty.list.notifications.filter.most_recent(nn, 3) end,
		shape = Helpers.shape.rrect(2),
		minimum_width = 280,
		maximum_width = 680,
		widget_template = {
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
								(n.actions and #n.actions > 0) and actions,
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
		},
	})
	notify.buttons = {}
	notify:connect_signal("mouse::enter", function()
		n:set_timeout(4294967)
	end)
	notify:connect_signal("mouse::leave", function()
		if n.urgency ~= "critical" then
			n:set_timeout(2)
		end
	end)
	notify:connect_signal("button::press", function()
		n:destroy()
	end)
	return notify
end
Naughty.connect_signal("request::display", function(n)
	if User.config.dnd_state or _G.notify_center_visible == true then
		Naughty.destroy_all_notifications(nil, 1)
	else
		mknotification(n)
	end
end)
require("layout.notifications.playerctl")
