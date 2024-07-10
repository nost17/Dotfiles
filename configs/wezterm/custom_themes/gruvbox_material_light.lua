local wezterm = require("wezterm")

local palette = {
	foreground = "#3c3836",
	background = "#f3eac7",
	cursor_bg = "#f3eac7",
	cursor_fg = "#282828",
	selection_fg = "#282828",
	selection_bg = "#6c782e",
	scrollbar_thumb = "#504945",
	split = "#504945",
	ansi = {},
	brights = {},
}

local function add_bright_color(color)
	color = wezterm.color.parse(color)
	table.insert(palette.ansi, color)
	table.insert(palette.brights, color:lighten(0.02))
end

add_bright_color("#b6a980")
add_bright_color("#c14a4a")
add_bright_color("#6c782e")
add_bright_color("#b57614")
add_bright_color("#076678")
add_bright_color("#8f3f71")
add_bright_color("#82b3a8")
add_bright_color("#504945")

return palette
