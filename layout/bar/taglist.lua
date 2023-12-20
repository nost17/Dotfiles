local function update_callback(self, tag, _, _)
	if tag.selected and #tag:clients() > 0 then
		self:get_children_by_id("indicator")[1].bg = Beautiful.taglist_fg_focus
	else
		self:get_children_by_id("indicator")[1].bg = Beautiful.transparent
	end
end
local function taglist(s)
	local mytaglist = Awful.widget.taglist({
		screen = s,
		filter = Awful.widget.taglist.filter.all,
		layout = { layout = Wibox.layout.fixed.horizontal },
		buttons = {
			Awful.button({}, 1, function(t)
				t:view_only()
			end),
			Awful.button({ User.config.modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			Awful.button({}, 3, Awful.tag.viewtoggle),
			Awful.button({ User.config.modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
		},
		widget_template = {
			{
				{
					id = "text_role",
					halign = "center",
					valign = "center",
					widget = Wibox.widget.textbox,
				},
				{
					{
						{
							id = "indicator",
							forced_height = Dpi(2),
							forced_width = Dpi(10),
							widget = Wibox.container.background,
						},
						valign = "bottom",
						layout = Wibox.container.place,
					},
					bottom = Dpi(4),
					widget = Wibox.container.margin,
				},
				layout = Wibox.layout.stack,
			},
			-- forced_height = 28,
			-- forced_width = 34,
			id = "background_role",
			update_callback = function(self, tag, _, _)
				update_callback(self, tag, _, _)
			end,
			create_callback = function(self, tag, _, _)
				update_callback(self, tag, _, _)
			end,
			widget = Wibox.container.background,
		},
	})
	local wdg = Wibox.widget({
		mytaglist,
		left = Dpi(8),
		right = Dpi(8),
		-- top = 3,
		widget = Wibox.container.margin,
	})
	wdg:add_button(Awful.button({}, 4, function(t)
		Awful.tag.viewprev(t.screen)
	end))
	wdg:add_button(Awful.button({}, 5, function(t)
		Awful.tag.viewnext(t.screen)
	end))
	return wdg
end
return taglist
