local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local screen_gap = Dpi(4)
local notification_center = require("layout.popups.date-panel.notification-center")

local main = Wibox({
	height = screen_height - Beautiful.main_panel_size - Dpi(4) - Beautiful.useless_gap * 2,
	width = Dpi(320),
	bg = Beautiful.bg_normal,
	visible = false,
	ontop = true,
	border_width = Dpi(2),
	border_color = Beautiful.black,
	screen = screen.primary,
})


if Beautiful.main_panel_pos == "top" then
  Helpers.placement(main, "top_right")
elseif Beautiful.main_panel_pos == "bottom" then
  Helpers.placement(main, "bottom_right")
end

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
		awesome.emit_signal("awesome::quicksettings", "hide")
	end
end)
main:setup({
	{
		notification_center,
		layout = Wibox.layout.fixed.vertical,
	},
	margins = Dpi(8),
	widget = Wibox.container.margin,
})
