-- Theme handling library
-- Standard awesome library
local gfs = Gears.filesystem
local theme = {}
local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local dpi = Beautiful.xresources.apply_dpi
local darken = Helpers.color.darken

theme = dofile(gfs.get_themes_dir() .. "default/theme.lua")
local _colors = require("theme.colorschemes.onedark")
local cscheme = require("theme.palettegen")(_colors, "dark")

theme.transparent = "#00000000"

theme.wallpaper = themes_path .. "assets/wallpapers/16.jpg"
theme.music_cover = themes_path .. "assets/no_music.png"
theme.user_icon = themes_path .. "assets/user_icon.png"

theme.bg_normal = cscheme.neutral[900]
theme.bg_alt = cscheme.neutral[700]
theme.bg_focus = cscheme.neutral[800]
theme.bg_urgent = cscheme.red[300]
theme.fg_normal = cscheme.neutral[100]
theme.fg_focus = cscheme.neutral[100]
theme.bg_systray = theme.bg_normal

theme.useless_gap = dpi(3)

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
    l = 14,
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
theme.font_name = _font.name
theme.font_icon = "Material Design Icons Desktop "
theme.font = font.font_reg_m

-- widget
theme.radius = dpi(2)
theme.widget_border = {
  width = 1,
  -- color = cscheme.type == "dark" and darken(cscheme.neutral[900], 0.2) or cscheme.neutral[600],
  -- color_inner = cscheme.type == "dark" and darken(cscheme.neutral[900], 0) or cscheme.neutral[600],
  -- color = Helpers.color.blend(cscheme.neutral[700], cscheme.neutral[850]),
  color = cscheme.type == "dark" and Helpers.color.blend(cscheme.neutral[800],cscheme.neutral[700]) or cscheme.neutral[600],
  color_inner = cscheme.type == "dark" and cscheme.neutral[700] or cscheme.neutral[600],
}
theme.widget_radius = {
  outer = theme.radius * 2,
  inner = theme.radius,
}
theme.widget_padding = {
  outer = dpi(10),
  inner = dpi(8),
}
theme.widget_spacing = theme.widget_padding.inner * 0.75

theme.border_width = 1
theme.border_color_normal = darken(cscheme.neutral[900], 0.15)
theme.border_color_active = cscheme.primary[500]

theme.titlebar_bg_normal = cscheme.neutral[850]
theme.titlebar_bg_focus = cscheme.neutral[800]

-- taglist
-- theme.taglist_bg_focus = cscheme.primary[500]
-- theme.taglist_bg_empty = cscheme.neutral[800]
-- theme.taglist_bg_occupied = cscheme.neutral[500]
theme.taglist_font = font.font_reg_m
theme.taglist_bg_focus = cscheme.primary[500]
theme.taglist_bg_empty = cscheme.neutral[850]
theme.taglist_bg_occupied = cscheme.neutral[850]
theme.taglist_fg_focus = cscheme.neutral[900]
theme.taglist_fg_occupied = cscheme.neutral[200]
theme.taglist_fg_empty = cscheme.neutral[600] .. "BB"
-- theme.taglist_shape = Helpers.shape.rrect(theme.radius)
-- theme.taglist_shape_border_width_focus = theme.widget_border.width
-- theme.taglist_shape_border_color_focus = theme.widget_border.color

-- tasklist
theme.tasklist_icon_size = dpi(18)
theme.tasklist_font = theme.font_name .. "Regular 10"
theme.tasklist_fg_normal = cscheme.neutral[300]
theme.tasklist_fg_focus = cscheme.neutral[100]
theme.tasklist_fg_minimize = cscheme.neutral[700]
theme.tasklist_bg_focus = cscheme.neutral[850]
-- theme.tasklist_bg_focus = Helpers.color.blend(cscheme.neutral[900], cscheme.primary[600]) .. "66"
theme.tasklist_bg_normal = cscheme.neutral[900]
theme.tasklist_bg_minimize = theme.transparent
theme.tasklist_shape = Helpers.shape.rrect(theme.radius)
theme.tasklist_shape_border_width = theme.widget_border.width
theme.tasklist_shape_border_color_focus = theme.widget_border.color
-- theme.tasklist_shape_border_color_focus = cscheme.primary[500] .. "88"
theme.tasklist_shape_border_color = theme.tasklist_bg_normal
-- theme.tasklist_shape = Gears.shape.rounded_bar

-- notifications
theme.notification_spacing = theme.widget_spacing
theme.notification_icon_height = dpi(52)
theme.notification_border_width = theme.widget_border.width
theme.notification_bg = Helpers.color.blend(cscheme.neutral[900], cscheme.neutral[850])
theme.notification_fg = cscheme.neutral[100]
theme.notification_border_color = theme.widget_border.color
theme.notification_timebar_bg = cscheme.neutral[800]
theme.notification_timebar_color = cscheme.primary[400]
theme.notification_icon_shape = Helpers.shape.rrect(theme.radius * 2)
theme.notification_font_message = font.font_reg_s
theme.notification_font_title = font.font_med_s
-- theme.notification_icon_shape = function(cr, w, h)
--   if math.abs(w - h) <= (h * 0.1) then
--     Gears.shape.squircle(cr, w, h, 2.5)
--   else
--     Gears.shape.squircle(cr, w, h, 4)
--   end
-- end

Beautiful.init(theme)

Gears.table.crush(theme, font)
Gears.table.crush(theme, cscheme)
Beautiful.icons = themes_path .. "assets/icons/"
