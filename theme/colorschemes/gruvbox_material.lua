local M = {
   ["dark"] = {
      type = "dark",
      primary = {},
      neutral = {
         dark = "#1d2122",
         light = "#a89984",
      },
      colors = {
         red = "#ea6962",
         green = "#a9b665",
         orange = "#e78a4e",
         yellow = "#d8a657",
         blue = "#7daea3",
         magenta = "#d3869b",
         cyan = "#89b482",
      },
   },
   ["light"] = {
      type = "light",
      primary = {},
      neutral = {
         dark = "#f3eac7",
         light = "#3c3836",
      },
      colors = {
         red = "#c14a4a",
         green = "#6c782e",
         orange = "#af3a03",
         yellow = "#b57614",
         blue = "#076678",
         magenta = "#8f3f71",
         cyan = "#598f8d",
         -- red = "#c14a4a",
         -- green = "#6c782e",
         -- orange = "#af3a03",
         -- yellow = "#b57614",
         -- blue = "#45707a",
         -- magenta = "#945e80",
         -- cyan = "#4c7a5d",
      },
   },
}

M["dark"].primary.base = M["dark"].colors.cyan
M["light"].primary.base = M["light"].colors.cyan

return M
