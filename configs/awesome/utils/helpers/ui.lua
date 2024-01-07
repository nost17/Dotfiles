local _module = {}

function _module.horizontal_pad(width)
	return Wibox.widget({
		forced_width = width,
		layout = Wibox.layout.fixed.horizontal,
	})
end

function _module.vertical_pad(height)
	return Wibox.widget({
		forced_height = height,
		layout = Wibox.layout.fixed.vertical,
	})
end

function _module.add_cursor_hover(element)
	local old_cursor, old_wibox
	element:connect_signal("mouse::enter", function(c)
		local wb = mouse.current_wibox
		old_cursor, old_wibox = wb.cursor, wb
		wb.cursor = "hand1"
	end)
	element:connect_signal("mouse::leave", function(c)
		if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
		end
	end)
end

function _module.add_hover(element, bg , fg, hbg, hfg)
	-- _module.add_cursor_hover(element)
	local nbg = bg or Beautiful.accent_color
	local nfg = fg or Helpers.color.isDark(nbg) and Beautiful.white or Beautiful.black
	element.bg = nbg
	element.fg = nfg
	hbg = hbg or Helpers.color.ldColor(nbg, 15)
	hfg = hfg or nfg
	element:connect_signal("mouse::enter", function(self)
		self.bg = hbg
		self.fg = hfg
	end)
	element:connect_signal("mouse::leave", function(self)
		self.bg = nbg
		self.fg = nfg
	end)
end

function _module.add_click(element, mouse, action)
	element:add_button(Awful.button({}, mouse, action))
end

function _module.add_hover_action(element, enter_fn, leave_fn)
	element:connect_signal("mouse::enter", function(_)
		if enter_fn then
			enter_fn()
		end
	end)
	element:connect_signal("mouse::leave", function(_)
		if leave_fn then
			leave_fn()
		end
	end)
end

return _module
