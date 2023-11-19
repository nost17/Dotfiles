local scroller = require("layout.popups.date-panel.notification-center.notifbox-scroll")
local builder = require("layout.popups.date-panel.notification-center.build-notify")
local core = {}
local empty_widget = Wibox.widget({
	{
		markup = Helpers.text.colorize_text("󰂛", Beautiful.accent_color),
		font = Beautiful.font_icon .. "32",
		widget = Wibox.widget.textbox,
	},
	halign = "center",
	valign = "center",
				content_fill_vertical = true,
	layout = Wibox.container.place,
})

core.remove_empty_widget = true
core.notifbox_layout = Wibox.layout.fixed.vertical()
core.notifbox_layout.spacing = 10
scroller(core.notifbox_layout)
core.reset = function()
	core.notifbox_layout:reset()
	core.notifbox_layout:insert(1, empty_widget)
	core.remove_empty_widget = true
end

local function add_notify(n)
	if #core.notifbox_layout.children == 1 and core.remove_empty_widget then
		core.notifbox_layout:reset(core.notifbox_layout)
		core.remove_empty_widget = false
	end
	local notify = builder(n)
	notify:add_button(Awful.button({}, 1, function()
		if #core.notifbox_layout.children == 1 then
			core.reset()
		else
			core.notifbox_layout:remove_widgets(notify, true)
		end
	end))
	core.notifbox_layout:insert(1, notify)
end
core.reset()

Naughty.connect_signal("request::display", function(n)
	add_notify(n)
end)
return core
