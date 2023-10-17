local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width
local screen_gap = 4

local main = Wibox({
	height = screen_height - 42 - 4 - (screen_gap * 2),
	width = 320,
	bg = Beautiful.bg_normal,
	visible = true,
	ontop = true,
  border_width = 2,
  border_color = Beautiful.widget_bg_alt,
})
main.y = screen_height - main.height - 42 - screen_gap
main.x = screen_width - main.width - screen_gap * 2

awesome.connect_signal("awesome::notification_center", function(action)
	if action == "toggle" then
		main.visible = not main.visible
	elseif action == "hide" then
		main.visible = false
	elseif action == "show" then
		main.visible = true
	end
end)
local notification_center = require("layout.popups.date-panel.notification-center")
main:setup({
  notification_center,
  layout = Wibox.layout.fixed.vertical,
})
