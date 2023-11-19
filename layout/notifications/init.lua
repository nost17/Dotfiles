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
	local app_icon_path = Helpers.misc.getIcon(n.app_name)
	for _, def_name in pairs(list_names) do
		if n.app_name == def_name then
			n.app_name = Naughty.config.defaults.app_name
		end
	end
	local n_title = require("layout.notifications.title")(n)
	local n_message = require("layout.notifications.message")(n)
	local n_image = require("layout.notifications.image")(n)
	local app_icon = mkimagew(app_icon_path, 16)
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
				spacing = 6,
				layout = Wibox.layout.fixed.horizontal,
			},
			nil,
			{
				{
					markup = Helpers.text.colorize_text("󰑊", accent_color),
					font = Beautiful.font_icon .. "9",
					halign = "center",
					valign = "center",
					widget = Wibox.widget.textbox,
				},
				widget = Wibox.container.margin,
				bottom = 2,
			},
			layout = Wibox.layout.align.horizontal,
		},
		left = 3,
		widget = Wibox.container.margin,
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
			shape = Helpers.shape.rrect(Beautiful.radius),
			-- forced_width = 70,
			widget = Wibox.container.background,
			create_callback = function(self, _, _, _)
				Helpers.ui.add_hover(
					self,
					Helpers.color.LDColor(
            Beautiful.color_method,
            Beautiful.color_method_factor,
            Beautiful.widget_bg_alt
          ),
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
		-- bg = "#00000000",
		bg = Beautiful.notification_bg,
		-- filter = function(nn) return Naughty.list.notifications.filter.most_recent(nn, 3) end,
		shape = Helpers.shape.rrect(Beautiful.notification_border_radius),
		minimum_width = 280,
		maximum_width = 480,
		widget_template = {
			{
				{
					n_appname,
					{
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
								left = 2,
								right = 2,
								layout = Wibox.container.margin,
							},
							(n.actions and #n.actions > 0) and actions,
							spacing = 6,
							layout = Wibox.layout.fixed.vertical,
						},
						layout = Wibox.container.margin,
					},
					spacing = 5,
					layout = Wibox.layout.fixed.vertical,
				},
				margins = 6,
				widget = Wibox.container.margin,
			},
			-- shape = Helpers.shape.rrect(Beautiful.notification_border_radius),
			bg = Beautiful.notification_bg,
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
