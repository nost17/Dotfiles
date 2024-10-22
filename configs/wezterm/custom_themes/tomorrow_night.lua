local wezterm = require("wezterm")

local palette = wezterm.color.get_builtin_schemes()["Tomorrow (dark) (terminal.sexy)"]
palette.ansi[1] = wezterm.color.parse(palette.ansi[1]):lighten(0.04)
palette.brights[1] = palette.ansi[1]:lighten(0.06)

return palette