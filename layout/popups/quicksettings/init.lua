local screen_height = screen.primary.geometry.height
local screen_width = screen.primary.geometry.width

local main = Wibox({
	height = 260,
	width = 320,
	bg = Beautiful.bg_normal,
	visible = false,
	ontop = true,
  border_width = 2,
  border_color = Beautiful.widget_bg_alt,
})
main.y = screen_height - main.height - 42
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
    spacing = 8,
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
  if main.visible then
        awesome.emit_signal("awesome::notification_center", "hide")
  end
end)
