local _module = {}
local capi = { mouse = mouse }

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

function _module.add_hover_cursor(w, hover_cursor)
	local original_cursor = "left_ptr"
  hover_cursor = hover_cursor or "hand1"
	w:connect_signal("mouse::enter", function()
		local widget = capi.mouse.current_wibox
		if widget then
			widget.cursor = hover_cursor
		end
	end)

	w:connect_signal("mouse::leave", function()
		local widget = capi.mouse.current_wibox
		if widget then
			widget.cursor = original_cursor
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
