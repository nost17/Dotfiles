-- Theme handling library
-- Standard awesome library
local gfs = Gears.filesystem
local theme = {}
local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local dpi = Beautiful.xresources.apply_dpi

theme = dofile(gfs.get_themes_dir() .. "default/theme.lua")
local _colors = require("theme.colorschemes.onedark")
local cscheme = require("theme.palettegen")(_colors, "dark")

theme.bg_normal = cscheme.neutral[900]
theme.bg_alt = cscheme.neutral[700]
theme.bg_focus = cscheme.neutral[800]
theme.bg_urgent = cscheme.red[300]

-- font
local _font = {
  name = "IBM Plex Sans ",
  weights = {
    light = "Light ",
    reg = "Regular ",
    med = "Medium ",
    bold = "Bold ",
  },
  sizes = {
    xxs = 5,
    xs = 8,
    s = 10,
    m = 12,
    l = 16,
    xl = 22,
    xxl = 32,
  },
}
local font = {}
for w_name, w_val in pairs(_font.weights) do
  for s_name, s_val in pairs(_font.sizes) do
    local fval = _font.name .. w_val .. dpi(s_val)
    local fname = "font_" .. w_name .. "_" .. s_name
    font[fname] = fval
  end
end
theme.font = font.font_reg_s

-- widget
theme.radius = dpi(3)
theme.widget_radius = {
  outer = theme.radius,
  inner = 0,
}
theme.widget_padding = {
  outer = dpi(15),
  inner = dpi(8),
}
theme.widget_spacing = theme.widget_padding.inner

Beautiful.init(theme)

Gears.table.crush(theme, font)
Gears.table.crush(theme, cscheme)
