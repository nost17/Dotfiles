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
}
