local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local screen_gap = 4

local main = Wibox({
	height = screen_height - 42 - 4 - (screen_gap * 2),
	width = 320,
	bg = Beautiful.bg_normal,
	visible = false,
	ontop = true,
	border_width = 2,
	border_color = Beautiful.black_alt,
})
main.y = screen_height - main.height - 42 - screen_gap
main.x = screen_width - main.width - screen_gap * 2 - 4

awesome.connect_signal("awesome::notification_center", function(action)
	if action == "toggle" then
		main.visible = not main.visible
	elseif action == "hide" then
		main.visible = false
	elseif action == "show" then
		main.visible = true
	end
	_G.notify_center_hide = not main.visible
	if main.visible then
		awesome.emit_signal("awesome::quicksettings_panel", "hide")
	end
end)
local notification_center = require("layout.popups.date-panel.notification-center")
main:setup({
	{
		notification_center,
		layout = Wibox.layout.fixed.vertical,
	},
	margins = 8,
	widget = Wibox.container.margin,
})
