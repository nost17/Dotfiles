local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local wallpapers = {
	themes_path .. "/wallpapers/onedark_1.png",
	themes_path .. "/wallpapers/onedark_2.png",
	themes_path .. "/wallpapers/onedark_3.png",
	themes_path .. "/wallpapers/waves.png",
}

return {
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
}
