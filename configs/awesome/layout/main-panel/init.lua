-- local wbutton = require("utils.button")
local main_panel_screen = screen.primary
local screen_height = main_panel_screen.geometry.height
local dpi = Beautiful.xresources.apply_dpi

local main_panel = Awful.wibar({
	screen = main_panel_screen,
	height = screen_height,
	width = Beautiful.main_panel_size,
	bg = Beautiful.bg_normal,
	position = Beautiful.main_panel_pos,
	visible = true,
})

local taglist = require("layout.main-panel.mods.taglist")(main_panel_screen)

main_panel:setup({
	layout = Wibox.layout.align.vertical,
	{
		widget = Wibox.container.margin,
		margins = dpi(5),
		taglist,
	},
	nil,
	nil,
})
