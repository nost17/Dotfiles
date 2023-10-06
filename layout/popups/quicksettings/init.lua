local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width

local main = Wibox({
	height = 260,
	width = 320,
	bg = Beautiful.bg_normal,
	visible = true,
	ontop = true,
})
main.y = screen_height - main.height - 42
main.x = screen_width - main.width - 135

-- PLAYERCTL WDG
local music = require("layout.popups.quicksettings.playerctl")

-- QUICKSETTINGS SETUP
main:setup({
	{
    music,
		layout = Wibox.layout.fixed.vertical,
	},
	margins = 8,
	widget = Wibox.container.margin,
})

-- SIGNAL
awesome.connect_signal("awesome::quicksettings_panel", function(action)
	if action == "toggle" then
		main.visible = not main.visible
	elseif action == "hide" then
		main.visible = false
	elseif action == "show" then
		main.visible = true
	end
end)
