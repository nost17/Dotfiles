-- Theme handling library
-- Standard awesome library
local gfs = Gears.filesystem
local theme = {}
local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local dpi = Beautiful.xresources.apply_dpi

theme = dofile(gfs.get_themes_dir() .. "default/theme.lua")
local _colors = require("theme.colorschemes.tomorrow")
local cscheme = require("theme.palettegen")(_colors, "dark")

theme.transparent = "#00000000"

theme.bg_normal = cscheme.neutral[900]
theme.bg_alt = cscheme.neutral[700]
theme.bg_focus = cscheme.neutral[800]
theme.bg_urgent = cscheme.red[300]
theme.fg_normal = cscheme.neutral[100]
theme.fg_focus = "#abb2bf"

-- font
local _font = {
  name = "Gabarito ",
  weights = {
    light = "Light ",
    reg = "Regular ",
    med = "Medium ",
    bold = "Bold ",
  },
  sizes = {
    xxs = 6,
    xs = 9,
    s = 11,
    m = 12,
    l = 15,
    xl = 28,
    xxl = 35,
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
theme.font = font.font_reg_m

-- widget
theme.radius = dpi(3)
theme.widget_border = {
  width = 0,
  color = cscheme.neutral[300],
}
theme.widget_radius = {
  outer = theme.radius,
  inner = 0,
}
theme.widget_padding = {
  outer = dpi(15),
  inner = dpi(8),
}
theme.widget_spacing = theme.widget_padding.inner

-- taglist
theme.taglist_bg_focus = cscheme.primary[500]
theme.taglist_bg_empty = cscheme.neutral[800]
theme.taglist_bg_occupied = cscheme.neutral[500]
theme.taglist_shape = Gears.shape.rounded_bar
theme.taglist_shape_border_width_focus = 0
theme.taglist_shape_border_color_focus = cscheme.neutral[100]

-- tasklist
theme.tasklist_icon_size = dpi(18)
theme.tasklist_bg_focus = cscheme.primary[500]
theme.tasklist_bg_normal = cscheme.neutral[700]
theme.tasklist_bg_minimize = theme.transparent
theme.tasklist_shape = Gears.shape.rounded_bar

-- notifications
theme.notification_spacing = theme.widget_spacing
theme.notification_border_width = theme.widget_border.width
theme.notification_border_color = theme.widget_border.color
theme.notification_timebar_bg = cscheme.neutral[800]
theme.notification_timebar_color = cscheme.primary[400]
theme.notification_icon_shape = function(cr, w, h)
  if math.abs(w - h) <= (h * 0.1) then
    Gears.shape.squircle(cr, w, h, 2.5)
  else
    Gears.shape.squircle(cr, w, h, 4)
  end
end

Beautiful.init(theme)

Gears.table.crush(theme, font)
Gears.table.crush(theme, cscheme)
