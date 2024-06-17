-- local imagebox = require("wibox.widget.imagebox")
local imagebox = Wibox.widget.imagebox
local icon = {}
function icon:set_notification(notif)
	local old = (self._private.notification or {})[1]

	if old == notif then
		return
	end

	if old then
		old:disconnect_signal("destroyed", self._private.icon_changed_callback)
	end

	local icn =notif.icon

	if icn then
		self:set_image(icn)
	end

	self._private.notification = setmetatable({ notif }, { __mode = "v" })

	notif:connect_signal("property::icon", self._private.icon_changed_callback)
	self:emit_signal("property::notification", notif)
end

local valid_strategies = {
	scale = true,
	center = true,
	resize = true,
}

function icon:set_resize_strategy(strategy)
	assert(valid_strategies[strategy], "Invalid strategy")

	self._private.resize_strategy = strategy

	self:emit_signal("widget::redraw_needed")
	self:emit_signal("property::resize_strategy", strategy)
end

function icon:get_resize_strategy()
	return self._private.resize_strategy or Beautiful.notification_icon_resize_strategy or "resize"
end

local function new(args)
	args = args or {}
	local tb = imagebox()
	tb.clip_shape = Beautiful.notification_icon_shape
	tb.valign = "center"
	tb.halign = "center"
	tb.scaling_quality = "good"
	-- tb.forced_width = beautiful.notification_icon_size
	-- tb.forced_height = Beautiful.notification_icon_height
	Gears.table.crush(tb, icon, true)
	tb._private.notification = {}
	function tb._private.icon_changed_callback()
		local n = tb._private.notification[1]
		if not n then
			return
		end
		local icn = n.icon
		if icn then
			tb:set_image(icn)
		end
	end

	if args.notification then
		tb:set_notification(args.notification)
	end
	return tb
end

return setmetatable(icon, {
	__call = function(_, ...)
		return new(...)
	end,
})
