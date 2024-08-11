local M = {
  ["dark"] = {
    type = "dark",
    primary = {},
    neutral = {
      -- dark = "#282c34",
      dark = "#21252B",
      -- base = "#696f79",
      light = "#abb2bf",
    },
    colors = {
      red = "#e06c75",
      green = "#98c379",
      orange = "#d19a66",
      yellow = "#e5c07b",
      blue = "#61afef",
      magenta = "#c678dd",
      cyan = "#56b6c2",
    },
  },
  ["light"] = {
    type = "light",
    primary = {},
    neutral = {
      dark = "#fafafa",
      light = "#202227",
    },
    colors = {
      red = "#d84a3d",
      green = "#50a14f",
      orange = "#ff6a00",
      yellow = "#c18401",
      blue = "#3485BF",
      magenta = "#a626a4",
      cyan = "#0b8ec6",
    },
  },
}

M["dark"].primary.base = M["dark"].colors.blue
M["light"].primary.base = M["light"].colors.blue

return M
