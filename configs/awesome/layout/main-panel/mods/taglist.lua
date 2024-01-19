local dpi = Beautiful.xresources.apply_dpi
local function taglist(s)
	local mytaglist = Awful.widget.taglist({
		screen = s,
		filter = Awful.widget.taglist.filter.all,
		layout = { layout = Wibox.layout.fixed.vertical },
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
			Awful.button({}, 4, function(t)
				Awful.tag.viewprev(t.screen)
			end),
			Awful.button({}, 5, function(t)
				Awful.tag.viewnext(t.screen)
			end),
		},
		widget_template = {
			layout = Wibox.container.place,
      content_fill_horizontal = true,
			{
				widget = Wibox.container.background,
				id = "background_role",
				{
					widget = Wibox.container.margin,
					bottom = Beautiful.taglist_icon_padding,
          top = Beautiful.taglist_icon_padding,
					{
						widget = Wibox.widget.textbox,
						id = "text_role",
						halign = "center",
						valign = "center",
					},
				},
			},
		},
	})
	local w = Wibox.widget({
		halign = "center",
		widget = Wibox.container.background,
		{
			widget = Wibox.container.background,
			bg = Beautiful.taglist_bg_color,
			shape = Helpers.shape.rrect(Beautiful.small_radius),
			{
				widget = Wibox.container.margin,
        margins = dpi(5),
				mytaglist,
			},
		},
	})
	return w
end
return taglist
