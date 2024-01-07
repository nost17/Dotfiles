-- local icons =
local getIcon = require("utils.modules.get_icon")
local create_task = function(self, c, _, _)
	self:get_children_by_id("icon_client")[1].image = getIcon({
		client = c,
		icon_size = 48,
	})
	-- self:get_children_by_id("icon_client")[1].image = Beautiful.GtkBling:get_client_icon_path(c)
	if c.minimized then
		self:get_children_by_id("icon_client")[1].opacity = 0.2
	end
end
local update_task = function(self, c, _, _)
	if c.minimized then
		self:get_children_by_id("icon_client")[1].opacity = 0.2
	else
		self:get_children_by_id("icon_client")[1].opacity = 1
	end
end
local tasklist = function(s)
	local task = Awful.widget.tasklist({
		screen = s,
		filter = Awful.widget.tasklist.filter.currenttags,
		buttons = {
			Awful.button({}, 1, function(c)
				if c == client.focus then
					c.minimized = true
				else
					c:emit_signal("request::activate", "tasklist", { raise = true })
				end
			end),
			Awful.button({}, 3, function(c)
				c:kill()
			end),
			Awful.button({}, 4, function()
				Awful.client.focus.byidx(1)
			end),
			Awful.button({}, 5, function()
				Awful.client.focus.byidx(-1)
			end),
		},
		layout = { spacing = Dpi(4), layout = Wibox.layout.fixed.horizontal },
		widget_template = {
			{
				{
					{
						id = "icon_client",
						halign = "center",
						valign = "center",
						widget = Wibox.widget.imagebox,
					},
					strategy = "exact",
					height = Beautiful.taglist_icon_size,
					width = Beautiful.taglist_icon_size,
					widget = Wibox.container.constraint,
				},
				left = Dpi(6),
				right = Dpi(6),
				widget = Wibox.container.margin,
			},
			id = "background_role",
			widget = Wibox.widget.background,
			create_callback = function(self, c, index, objects)
				create_task(self, c, index, objects)
				-- update_task(self, c, index, objects)
			end,
			update_callback = function(self, c, index, objects)
				-- create_task(self, c, index, objects)
				update_task(self, c, index, objects)
			end,
		},
	})
	return task
end

return tasklist
