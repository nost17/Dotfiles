local quicksettings = Wibox({
	screen = screen.primary,
	height = Dpi(390),
	width = Dpi(824),
	bg = Beautiful.widget_bg_color,
	visible = false,
	ontop = true,
	border_width = Dpi(2),
	shape = Helpers.shape.rrect(Beautiful.medium_radius),
	border_color = Beautiful.widget_bg_alt,
	-- border_color = Beautiful.red,
})

local placement = Awful.placement.center_horizontal
local placement_props = { honor_workarea = true, margins = Beautiful.useless_gap }

if Beautiful.main_panel_pos == "bottom" then
	placement = placement + Awful.placement.bottom
	placement(quicksettings, placement_props)
elseif Beautiful.main_panel_pos == "top" then
	placement = placement + Awful.placement.top
	placement(quicksettings, placement_props)
end

awesome.connect_signal("awesome::quicksettings", function(action)
	if action == "toggle" then
		quicksettings.visible = not quicksettings.visible
		awesome.emit_signal("visible::quicksettings", quicksettings.visible)
	elseif action == "hide" then
		quicksettings.visible = false
		awesome.emit_signal("visible::quicksettings", quicksettings.visible)
	elseif action == "show" then
		quicksettings.visible = true
		awesome.emit_signal("visible::quicksettings", quicksettings.visible)
	end
	if quicksettings.visible then
		awesome.emit_signal("awesome::notification_center", "hide")
	end
end)

Awful.mouse.append_client_mousebinding(Awful.button({}, 1, function(_)
	awesome.emit_signal("awesome::quicksettings", "hide")
end))

Awful.mouse.append_global_mousebinding(Awful.button({}, 1, function(c)
	awesome.emit_signal("awesome::quicksettings", "hide")
end))

Beautiful.quicksettings_widgets_shape =  Helpers.shape.rrect(Beautiful.medium_radius)
Beautiful.quicksettings_widgets_border_width = 2

local user_info = require("layout.popups.quicksettings.user_info")
local music_player_control = require("layout.popups.quicksettings.music-player")
local controls = require("layout.popups.quicksettings.controls")
local calendar = require("layout.popups.quicksettings.calendar")

quicksettings:setup({
	widget = Wibox.container.margin,
	margins = Dpi(10),
	{
		layout = Wibox.layout.fixed.vertical,
		fill_space = true,
		spacing = Dpi(10),
		user_info,
		{
			layout = Wibox.layout.flex.horizontal,
			spacing = Dpi(10),
			calendar,
			controls,
			music_player_control,
		},
	},
})

collectgarbage("collect")
