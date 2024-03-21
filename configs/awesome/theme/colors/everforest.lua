local themes_path = "/home/corvus/code/github/everforest-walls-main/"
local walls = {
  themes_path .. "awesomewm/awesomewm_rainbow.png",
  themes_path .. "close_up/flowers.png"
}

return {
  ["dark"] = {
    wallpaper = walls[2],
    wallpaper_alt = walls[2],
    foreground = "#D3C6AA",
    background = "#2b3339",
    foreground_alt = "#2b3339",
    black = "#363e44",
    red = "#e67e80",
    green = "#a7c080",
    yellow = "#dbbc7f",
    blue = "#7fbbb3",
    magenta = "#d699b6",
    cyan = "#83c092",
    gray = "#d3c6aa",
    orange = "#e69875",
  },
  ["light"] = {
    wallpaper = walls[2],
    wallpaper_alt = walls[2],
    foreground = "#495157",
    background = "#fff9e8",
    foreground_alt = "#fff9e8",
    black = "#363e44",
    red = "#ef615e",
    green = "#8da101",
    yellow = "#dfa000",
    blue = "#5f9b93",
    magenta = "#b67996",
    cyan = "#87a060",
    gray = "#B3AD9C",
    orange = "#F7954F",
  }  
}