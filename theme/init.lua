local theme = {}
local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local function check(file)
  file_path = themes_path:gsub("theme/", "") .. file:gsub("%.", "/") .. ".lua"
  return Helpers.misc.checkFile(file_path)
end
local theme_light_path = "theme." .. User.config.theme .. ".light"
local theme_dark_path = "theme." .. User.config.theme .. ".dark"

theme.ToggleDarkMode = function ()
  if User.config.dark_mode and check(theme_dark_path) then
    theme = require(theme_dark_path)
  else
    if check(theme_light_path) then
      theme = require(theme_light_path)
      User.config.dark_mode = false
    else
      theme = require(theme_dark_path)
      User.config.dark_mode = true
    end
  end
end
theme.ToggleDarkMode()

-- OTHER
theme.wallpaper                        = themes_path .. "/wallpapers/yoru.jpeg"
theme.font_text                        = "Sofia Sans "
theme.font_icon                        = "Material Design Icons Desktop "
theme.font                             = theme.font_text .. "Regular 12"
theme.widget_radius                    = 1
theme.radius                           = Dpi(8)
theme.default_app_icon                 = "access"
theme.icon_theme                       = "Qogir-dark"
theme.icon_theme_path                  = "/usr/local/share/icons/" .. theme.icon_theme .. "/scalable/apps/"
theme.accent_color                     = theme[User.config.theme_accent or "blue"]
theme.transparent                      = "#00000000"
theme.color_method                     = User.config.dark_mode and "lighten" or "darken"
theme.color_method_factor              = theme.color_method == "lighten" and 0.05 or 0.08

--- MAIN
theme.bg_normal                        = theme.background
theme.fg_normal                        = theme.foreground
theme.useless_gap                      = Dpi(4)
theme.gap_single_client                = false
theme.awesome_icon                     = themes_path .. "images/awesome.png"
-- theme.awesome_icon = themes_path .. "images/awesome.png"

-- BORDER
theme.border_width                     = 2
theme.border_normal                    = "#0c0e0f"
theme.border_focus                     = theme.yellow

-- WIDGETS
theme.widget_bg_color                  = theme.bg_normal
theme.widget_bg_alt                    = Helpers.color.LDColor(theme.color_method, theme.color_method_factor, theme.bg_normal)
theme.widget_clock_font                = theme.font_text .. 'Medium 11'
theme.layouts_icons_color              = Helpers.color.ldColor(theme.fg_normal, -30)
theme.bg_systray                       = theme.widget_bg_alt
theme.music_metadata_pos               = "left"
theme.music_control_pos                = "left"
theme.music_cover_default              = themes_path .. "images/default_music_cover.jpeg"
theme.main_panel_pos                   = "top"
theme.main_panel_size                  = Dpi(42)

-- TOOLTIP
theme.tooltip_bg                       = theme.bg_normal
theme.tooltip_fg                       = theme.fg_normal
theme.tooltip_margins                  = Dpi(10)

-- BLING
theme.bling_launcher_args              = {
  placement = Awful.placement.bottom_left,
  apps_per_column = 1,
  background = theme.background,
  -- icon_size = 32,
  apps_spacing = Dpi(6),
  app_show_icon = false,
  app_name_halign = "left",
  app_shape = Helpers.shape.rrect(theme.widget_radius - 5),
  apps_per_row = Dpi(6),
  app_height = Dpi(24),
  app_width = Dpi(260),
  apps_margin = Dpi(6),
  app_selected_color = theme.widget_bg_color,
  app_normal_color = theme.background,
  app_name_selected_color = theme.accent_color .. "EF",
  app_name_normal_color = theme.foreground .. "6F",
  app_name_font = theme.font_text .. "Regular 12",
  prompt_height = Dpi(40),
  prompt_margins = 0,
  prompt_paddings = {
    left = Dpi(20), right = Dpi(30),
  },
  prompt_text = "",
  prompt_icon = ">", -- 󰍉
  prompt_icon_font = theme.font_text .. "Medium 10",
  prompt_font = theme.font_text .. "Medium 11",
  prompt_color = theme.black,
  prompt_text_color = theme.foreground .. "bb",
  prompt_icon_color = theme.accent_color .. "DF",
  prompt_cursor_color = theme.foreground .. "bb",
  border_color = theme.black,
  border_width = Dpi(3),
}
theme.GtkBling                         = require("utils.mods.bling.helpers.icon_theme")(theme.icon_theme)

-- MENU

theme.menu_bg_normal = theme.widget_bg_color
theme.menu_bg_focus = theme.red
theme.menu_fg_focus = theme.foreground_alt
theme.menu_height = 26
theme.menu_width = 260

-- TITLEBAR
-- theme.titlebar_bg_focus                = Helpers.color.ldColor(theme.blue, -25)
-- theme.titlebar_bg_normal               = Helpers.color.ldColor(theme.bg_normal, 8)
theme.titlebar_bg_normal = "#0c0e0f"
theme.titlebar_bg_focus                = theme.titlebar_bg_normal
theme.titlebar_fg_normal               = theme.titlebar_bg_normal
theme.titlebar_fg_focus                = theme.fg_normal .. "BF"
theme.titlebar_font                    = theme.font_text .. "SemiBold 10"
theme.titlebar_size                    = 34

-- TASKLIST
theme.tasklist_bg_color                = theme.transparent
--[[ theme.tasklist_bg_focus                = Helpers.color.ldColor(theme.accent_color, 10) ]]
theme.tasklist_bg_focus                = User.config.dark_mode and Helpers.color.ldColor(theme.widget_bg_alt, 7) or theme.widget_bg_alt
theme.tasklist_indicator_focus         = theme.accent_color
theme.tasklist_indicator_normal        = theme.foreground .. "22"
theme.taglist_icon_size                = Dpi(24)

-- TAGLIST
theme.taglist_shape                    = Helpers.shape.rrect(theme.widget_radius)
theme.taglist_font                     = theme.font_text .. "Bold 12"
theme.taglist_spacing                  = Dpi(12)
theme.taglist_shape_border_width       = 0
theme.taglist_shape_border_color       = theme.background
theme.taglist_bg_color                 = theme.bg_normal
theme.taglist_bg_urgent                = theme.taglist_bg_color
theme.taglist_bg_focus                 = theme.taglist_bg_color
theme.taglist_bg_occupied              = theme.taglist_bg_color
theme.taglist_bg_empty                 = theme.taglist_bg_color
theme.taglist_fg_focus                 = theme.accent_color
theme.taglist_fg_urgent                = theme.red
theme.taglist_fg_occupied              = theme.fg_normal
theme.taglist_fg_empty                 = theme.black
theme.taglist_shape_border_color_empty = "#00000000"

-- NOTIFICATIONS
theme.notification_position            = "top_middle"
theme.notification_icon                = themes_path .. "images/notification.png"
theme.notification_bg                  = Helpers.color.LDColor(theme.color_method, theme.color_method_factor * 0.75, theme.bg_normal)
theme.notification_fg                  = Helpers.color.ldColor(theme.fg_normal, -15)
theme.notification_font_title          = theme.font_text .. "SemiBold 11"
theme.notification_font_message        = theme.font_text .. "Medium 10"
theme.notification_font_appname        = theme.font_text .. "Bold 10"
theme.notification_font_actions        = theme.font_text .. "Medium 9"
theme.notification_font_hour           = theme.font_text .. "Bold 10"
theme.notification_icon_shape          = Helpers.shape.rrect(6) -- Gears.shape.circle
theme.notification_spacing             = Dpi(6)
theme.notification_icon_height         = Dpi(48)
theme.notification_border_width        = 0
theme.notification_border_color        = theme.black
theme.notification_border_radius       = Dpi(6)
theme.notification_padding             = Dpi(8)

-- MENUBAR
theme.menubar_fg_normal                = theme.fg_normal .. "bb"
theme.menubar_bg_normal                = theme.black
theme.menubar_border_width             = 6
theme.menubar_border_color             = theme.black
theme.menubar_fg_focus                 = theme.foreground_alt
theme.menubar_bg_focus                 = theme.magenta
theme.menubar_font                     = theme.font_text .. "Medium 16"

-- LAYOUT BOX
theme.layout_fairh                     = themes_path .. "images/layouts/fairhw.png"
theme.layout_fairv                     = themes_path .. "images/layouts/fairvw.png"
theme.layout_floating                  = themes_path .. "images/layouts/floatingw.png"
theme.layout_magnifier                 = themes_path .. "images/layouts/magnifierw.png"
theme.layout_max                       = themes_path .. "images/layouts/maxw.png"
theme.layout_fullscreen                = themes_path .. "images/layouts/fullscreenw.png"
theme.layout_tilebottom                = themes_path .. "images/layouts/tilebottomw.png"
theme.layout_tileleft                  = themes_path .. "images/layouts/tileleftw.png"
theme.layout_tile                      = themes_path .. "images/layouts/tilew.png"
theme.layout_tiletop                   = themes_path .. "images/layouts/tiletopw.png"
theme.layout_spiral                    = themes_path .. "images/layouts/spiralw.png"
theme.layout_dwindle                   = themes_path .. "images/layouts/dwindlew.png"
theme.layout_cornernw                  = themes_path .. "images/layouts/cornernww.png"
theme.layout_cornerne                  = themes_path .. "images/layouts/cornernew.png"
theme.layout_cornersw                  = themes_path .. "images/layouts/cornersww.png"
theme.layout_cornerse                  = themes_path .. "images/layouts/cornersew.png"
for _, layout_name in ipairs({
  'layout_fairh',
  'layout_fairv',
  'layout_floating',
  'layout_magnifier',
  'layout_max',
  'layout_fullscreen',
  'layout_tilebottom',
  'layout_tileleft',
  'layout_tile',
  'layout_tiletop',
  'layout_spiral',
  'layout_dwindle',
  'layout_cornernw',
  'layout_cornerne',
  'layout_cornersw',
  'layout_cornerse',
}) do
  theme[layout_name] = Helpers.misc.recolor_image(theme[layout_name], theme.layouts_icons_color)
end

Beautiful.init(theme)
