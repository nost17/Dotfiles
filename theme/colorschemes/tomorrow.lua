local M = {
  ["dark"] = {
    type = "dark",
    primary = {},
    neutral = {
      light = "#c5c8c6",
      dark = "#1d1f21",
    },
    colors = {
      red = "#D77C79",
      green = "#C2C77B",
      orange = "#C78E63",
      yellow = "#F4CF86",
      blue = "#92B2CA",
      magenta = "#C0A7C7",
      cyan = "#9AC9C4",
    },
  },
  ["light"] = {
    type = "light",
    primary = {},
    neutral = {
      dark = "#ffffff",
      light = "#4c4c4c",
    },
    colors = {
      red = "#D43E36",
      green = "#839B00",
      orange = "#F99927",
      yellow = "#EFC200",
      blue = "#5286BC",
      magenta = "#9C71B7",
      cyan = "#4BA8AF",
    },
  },
}

M["dark"].primary.base = M["dark"].colors.blue
M["light"].primary.base = M["light"].colors.blue

return M
