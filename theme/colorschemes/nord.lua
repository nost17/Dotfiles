local M = {
  ["dark"] = {
    type = "dark",
    primary = {},
    neutral = {
      dark = "#2e3440",
      light = "#d8dee9",
    },
    colors = {
      red = "#bf616a",
      green = "#a3be8c",
      orange = "#d08770",
      yellow = "#ebcb8b",
      blue = "#6791c9",
      magenta = "#b48ead",
      cyan = "#88c0d0",
    },
  },
  ["light"] = {
    type = "light",
    primary = {},
    neutral = {
      dark = "#2e3440",
      light = "#d8dee9",
    },
    colors = {
      red = "#bf616a",
      green = "#a3be8c",
      orange = "#d08770",
      yellow = "#ebcb8b",
      blue = "#6791c9",
      magenta = "#b48ead",
      cyan = "#88c0d0",
    },
  },
}

M["dark"].primary.base = M["dark"].colors.blue
M["light"].primary.base = M["light"].colors.blue

return M
