local wbutton = require("utils.button")
local screen_height = screen.primary.geometry.height
local dpi = Beautiful.xresources.apply_dpi

local main_panel = Awful.wibar({
	height = screen_height,
	width = Beautiful.main_panel_size,
	bg = Beautiful.bg_normal,
	position = Beautiful.main_panel_pos,
	visible = true,
})

local text_example = Wibox.widget({
	markup = Helpers.text.colorize_text("HH", Beautiful.foreground_alt),
	halign = "center",
	valign = "center",
	font = Beautiful.font_text .. "Regular 13",
	widget = Wibox.widget.textbox,
})

main_panel:setup({
	layout = Wibox.layout.align.vertical,
})
