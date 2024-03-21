local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local wallpapers = {
	themes_path .. "/wallpapers/onedark_1.png",
	themes_path .. "/wallpapers/onedark_2.png",
	themes_path .. "/wallpapers/onedark_3.png",
	themes_path .. "/wallpapers/waves.png",
	themes_path .. "/wallpapers/waves_2.jpg",
}

return {
	["dark"] = {
		wallpaper = wallpapers[5],
		wallpaper_alt = wallpapers[4],
		foreground = "#abb2bf",
		background = "#282c34",
		foreground_alt = "#282c34",
		black = "#363B42",
		red = "#e06c75",
		green = "#98c379",
		orange = "#d19a66",
		yellow = "#e5c07b",
		blue = "#61afef",
		magenta = "#c678dd",
		cyan = "#56b6c2",
		gray = "#abb2bf",
	},
	["light"] = {
		wallpaper = wallpapers[3],
		wallpaper_alt = wallpapers[4],
		foreground = "#202227",
		background = "#fafafa",
		foreground_alt = "#fafafa",
		black = "#dadadb",
		red = "#d84a3d",
		green = "#50a14f",
		orange = "#ff6a00",
		yellow = "#c18401",
		blue = "#3485BF",
		magenta = "#a626a4",
		cyan = "#0b8ec6",
		gray = "#b7b7b8",
	},
}
