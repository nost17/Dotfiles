local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local wallpapers = {
  themes_path .. "/wallpapers/waves_2.jpg",
}

return {
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
}
