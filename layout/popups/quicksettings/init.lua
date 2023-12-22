local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width

local main = Wibox({
	height = Dpi(280),
	width = Dpi(300),
	bg = Beautiful.bg_normal,
	visible = false,
	ontop = true,
	border_width = Dpi(2),
	border_color = Beautiful.widget_bg_alt,
})

if Beautiful.main_panel_pos == "top" then
	main.y = Beautiful.main_panel_size
elseif Beautiful.main_panel_pos == "bottom" then
	main.y = screen_height - main.height - Beautiful.main_panel_size
end
main.x = screen_width - main.width - main.border_width - Beautiful.useless_gap * 2

-- MUSIC PLAYER WDG
local music = require("layout.popups.quicksettings.music-player")
-- SLIDERS WDG
local slider_bars = require("layout.popups.quicksettings.sliders")
-- QUICKSETTINGS CONTROL BUTTONS WDG
local controls = require("layout.popups.quicksettings.controls")
-- QUICKSETTINGS SETUP
main:setup({
	{
		music,
		controls,
		slider_bars,
		spacing = Dpi(8),
		layout = Wibox.layout.fixed.vertical,
	},
	margins = Dpi(8),
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
	if main.visible then
		awesome.emit_signal("awesome::notification_center", "hide")
	end
end)
