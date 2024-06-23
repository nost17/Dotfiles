local M = {
  ["dark"] = {
    type = "dark",
    primary = {},
    neutral = {
      dark = "#2b3339",
      light = "#D3C6AA",
    },
    colors = {
      red = "#e67e80",
      green = "#a7c080",
      orange = "#e69875",
      yellow = "#dbbc7f",
      blue = "#7fbbb3",
      magenta = "#d699b6",
      cyan = "#83c092",
    },
  },
  ["light"] = {
    type = "light",
    primary = {},
    neutral = {
      dark = "#fff9e8",
      light = "#2b3339",
    },
    colors = {
      red = "#ef615e",
      green = "#8da101",
      yellow = "#dfa000",
      blue = "#5f9b93",
      magenta = "#b67996",
      cyan = "#87a060",
      orange = "#F7954F",
    },
  },
}

M["dark"].primary.base = M["dark"].colors.blue
M["light"].primary.base = M["light"].colors.blue

return M
