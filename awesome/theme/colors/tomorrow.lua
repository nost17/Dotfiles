local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local wallpapers = {
	themes_path .. "/wallpapers/waves_2.jpg",
}

return {
	["dark"] = {
		wallpaper = wallpapers[1],
		foreground = "#c5c8c6",
		background = "#1d1f21",
		foreground_alt = "#27292C",
		black = "#27292C",
		red = "#D77C79",
		green = "#C2C77B",
		orange = "#C78E63",
		yellow = "#F4CF86",
		blue = "#92B2CA",
		magenta = "#C0A7C7",
		cyan = "#9AC9C4",
		gray = "#b4b7b4",
	},
	["light"] = {
		wallpaper = wallpapers[1],
		foreground = "#4c4c4c",
		background = "#ffffff",
		foreground_alt = "#ffffff",
		black = "#60605F",
		red = "#D43E36",
		green = "#839B00",
		orange = "#F99927",
		yellow = "#EFC200",
		blue = "#5286BC",
		magenta = "#9C71B7",
		cyan = "#4BA8AF",
		gray = "#9FA19E",
	},
}
