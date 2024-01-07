local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local screen_gap = Dpi(4)

local main = Wibox({
	height = screen_height - Beautiful.main_panel_size - Dpi(4) - (screen_gap * 2),
	width = Dpi(320),
	bg = Beautiful.bg_normal,
	visible = false,
	ontop = true,
	border_width = Dpi(2),
	border_color = Beautiful.black,
	screen = screen.primary,
})

if Beautiful.main_panel_pos == "top" then
	main.y = Beautiful.main_panel_size
elseif Beautiful.main_panel_pos == "bottom" then
	main.y = screen_height - main.height - Dpi(42) - screen_gap
end
main.x = screen_width - main.width - screen_gap * 2 - Dpi(4)

awesome.connect_signal("awesome::notification_center", function(action)
	if action == "toggle" then
		main.visible = not main.visible
	elseif action == "hide" then
		main.visible = false
	elseif action == "show" then
		main.visible = true
	end
	_G.notify_center_visible = main.visible
	if main.visible then
		Naughty.destroy_all_notifications(nil, 1)
		awesome.emit_signal("awesome::quicksettings_panel", "hide")
	end
end)
local notification_center = require("layout.popups.date-panel.notification-center")
main:setup({
	{
		notification_center,
		layout = Wibox.layout.fixed.vertical,
	},
	margins = Dpi(8),
	widget = Wibox.container.margin,
})
