local color_lib = Helpers.color
local theme = {}
local themes_path = Gears.filesystem.get_configuration_dir() .. "theme/"
local dpi = Beautiful.xresources.apply_dpi
local function check(file)
	file_path = themes_path:gsub("theme/", "") .. file:gsub("%.", "/") .. ".lua"
	return Helpers.checkFile(file_path)
end
local theme_dark_path = "theme.colors." .. User.config.theme
local theme_light_path = "theme.colors." .. User.config.theme .. "_light"
_G.light_theme_exist = check(theme_light_path)
_G.dark_theme_exist = check(theme_dark_path)
local setTheme = function()
	if User.config.dark_mode and _G.dark_theme_exist then
		theme = require(theme_dark_path)
	else
		if _G.light_theme_exist then
			theme = require(theme_light_path)
			User.config.dark_mode = false
		else
			theme = require(theme_dark_path)
			User.config.dark_mode = true
		end
	end
end
setTheme()

-- OTHER
theme.wallpaper = theme.wallpaper or themes_path .. "/wallpapers/yoru.jpeg"
theme.font_text = "IBM Plex Sans "
theme.font_icon = "Material Design Icons Desktop "
theme.font = theme.font_text .. "Regular 12"
theme.default_app_icon = "access"
-- theme.icon_theme                       = "ePapirus-Dark"
theme.accent_color = theme[User.config.theme_accent or "blue"]
theme.transparent = "#00000000"
theme.color_method = User.config.dark_mode and "lighten" or "darken"
theme.color_method_factor = User.config.dark_mode and 7 or 20

--- MAIN
theme.bg_normal = theme.background
theme.fg_normal = theme.foreground
theme.master_width_factor = 0.60
theme.useless_gap = dpi(4)
theme.gap_single_client = true
theme.awesome_icon = themes_path .. "images/awesome.png"
theme.user_icon = themes_path .. "images/user_icon.png"
theme.small_radius = dpi(2)
theme.medium_radius = dpi(5)

-- WIDGETS
theme.widget_bg = theme.bg_normal
theme.widget_bg_alt = color_lib.lightness(theme.color_method, theme.color_method_factor, theme.widget_bg)
theme.widget_clock_font = theme.font_text .. "Medium 10"
theme.bg_systray = theme.widget_bg
theme.main_panel_pos = "left"
theme.main_panel_size = dpi(43)

-- BORDER
theme.border_width = 0
theme.border_width_normal = theme.border_width
theme.border_width_active = theme.border_width
theme.border_width_new = theme.border_width
theme.border_width_floating = theme.border_width
theme.border_width_floating_normal = theme.border_width
theme.border_width_floating_active = theme.border_width
theme.border_width_floating_urgent = theme.border_width
theme.border_width_floating_new = theme.border_width
theme.border_normal = theme.widget_bg_alt
theme.border_focus = theme.accent_color
theme.border_color_urgent = theme.red

-- LOGOUT SCREEN
theme.logoutscreen_buttons_shape = Helpers.shape.rrect(theme.small_radius)

-- MUSIC CONTROL WIDGET
theme.music_metadata_pos = "left"
theme.music_control_pos = "left"
theme.music_cover_default = themes_path .. "images/default_music_cover.jpeg"
theme.music_title_font_size = 12
theme.music_artist_font_size = 11

-- TOOLTIP
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal
theme.tooltip_margins = dpi(10)

-- BLING
theme.GtkBling = require("utils.mods.bling.helpers.icon_theme")(theme.icon_theme)

-- MENU
theme.menu_bg_normal = theme.widget_bg
theme.menu_bg_focus = theme.red
theme.menu_fg_focus = theme.foreground_alt
theme.menu_height = 26
theme.menu_width = 260

-- TITLEBAR

theme.titlebar_bg_normal = theme.widget_bg_alt
theme.titlebar_bg_focus = theme.titlebar_bg_normal
theme.titlebar_fg_normal = theme.fg_normal .. "AF"
theme.titlebar_fg_focus = theme.fg_normal
theme.titlebar_bg_urgent = theme.titlebar_bg_normal
theme.titlebar_fg_urgent = theme.red
theme.titlebar_font = theme.font_text .. "Medium 10"
theme.titlebar_size = dpi(40)
local recolor_image = Gears.color.recolor_image
local recolor = function(color, method)
	return color_lib.lightness(method or "lighten", 35, color)
end
theme.titlebar_close_button_normal =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", recolor(theme.widget_bg_alt, "lighten"))
theme.titlebar_close_button_focus = recolor_image(themes_path .. "images/titlebar/close_icon.png", theme.red)
theme.titlebar_minimize_button_normal =
	recolor_image(themes_path .. "images/titlebar/minimize_icon.png", recolor(theme.widget_bg_alt, "lighten"))
theme.titlebar_minimize_button_focus = recolor_image(themes_path .. "images/titlebar/minimize_icon.png", theme.green)
theme.titlebar_maximized_button_normal_active =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", recolor(theme.widget_bg_alt, "lighten"))
theme.titlebar_maximized_button_normal_inactive =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", recolor(theme.widget_bg_alt, "lighten"))
theme.titlebar_maximized_button_focus_active =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", theme.orange or theme.yellow)
theme.titlebar_maximized_button_focus_inactive =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", theme.orange or theme.yellow)
-- TITLEBAR NORMAL HOVER
theme.titlebar_close_button_normal_hover =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", recolor(theme.red))
theme.titlebar_minimize_button_normal_hover =
	recolor_image(themes_path .. "images/titlebar/minimize_icon.png", recolor(theme.green))
theme.titlebar_maximized_button_normal_active_hover =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", recolor(theme.orange or theme.yellow))
theme.titlebar_maximized_button_normal_inactive_hover =
	recolor_image(themes_path .. "images/titlebar/close_icon.png", recolor(theme.orange or theme.yellow))
-- TITLEBAR FOCUS HOVER
theme.titlebar_close_button_focus_hover = theme.titlebar_close_button_normal_hover
theme.titlebar_minimize_button_focus_hover = theme.titlebar_minimize_button_normal_hover
theme.titlebar_maximized_button_focus_active_hover = theme.titlebar_maximized_button_normal_active_hover
theme.titlebar_maximized_button_focus_inactive_hover = theme.titlebar_maximized_button_normal_inactive_hover

-- TASKLIST
theme.tasklist_bg_color = theme.transparent
--[[ theme.tasklist_bg_focus                = color_lib.lightness(theme.accent_color, 10) ]]
theme.tasklist_bg_focus = theme.widget_bg_alt
theme.tasklist_indicator_focus = theme.accent_color
theme.tasklist_indicator_normal = theme.foreground .. "22"
theme.tasklist_indicator_minimized = theme.transparent
theme.tasklist_indicator_position = "left"
theme.tasklist_icon_size = dpi(24)
theme.tasklist_spacing = dpi(5)

-- TAGLIST
theme.taglist_shape = Helpers.shape.rrect(theme.small_radius)
theme.taglist_font = theme.font_text .. "SemiBold 12"
theme.taglist_spacing = dpi(6)
theme.taglist_icon_padding = 2
theme.taglist_shape_border_width = 0
theme.taglist_shape_border_color = theme.background
theme.taglist_bg_color = theme.widget_bg_alt
theme.taglist_bg_urgent = theme.red
theme.taglist_bg_focus = theme.accent_color
theme.taglist_bg_occupied = theme.taglist_bg_color
theme.taglist_bg_empty = theme.taglist_bg_color
theme.taglist_fg_focus = theme.foreground_alt
theme.taglist_fg_urgent = theme.foreground_alt
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_fg_empty = theme.fg_normal .. "55"
theme.taglist_shape_border_color_empty = "#00000000"

-- NOTIFICATIONS
theme.notification_position = "top_right"
theme.notification_icon = themes_path .. "images/notification.png"
theme.notification_bg = color_lib.lightness(theme.color_method, theme.color_method_factor * 0.5, theme.widget_bg)
theme.notification_bg_alt = color_lib.lightness(theme.color_method, theme.color_method_factor, theme.notification_bg)
theme.notification_fg = color_lib.lightness("darken", 15, theme.fg_normal)
theme.notification_font_title = theme.font_text .. "Bold 11"
theme.notification_font_message = theme.font_text .. "Medium 11"
theme.notification_font_appname = theme.font_text .. "Regular 10"
theme.notification_font_actions = theme.font_text .. "Medium 10"
theme.notification_font_hour = theme.font_text .. "Bold 10"
theme.notification_icon_shape = Helpers.shape.rrect(theme.small_radius) -- Gears.shape.circle
theme.notification_spacing = dpi(6)
theme.notification_icon_height = dpi(58)
theme.notification_border_width = 0
theme.notification_border_color = theme.black
theme.notification_border_radius = theme.small_radius
theme.notification_icon_type = "image"
theme.notification_padding = dpi(12)

-- MENUBAR
theme.menubar_fg_normal = theme.fg_normal .. "bb"
theme.menubar_bg_normal = theme.black
theme.menubar_border_width = 6
theme.menubar_border_color = theme.black
theme.menubar_fg_focus = theme.foreground_alt
theme.menubar_bg_focus = theme.magenta
theme.menubar_font = theme.font_text .. "Medium 16"

-- HOTKEYS POPUP
theme.hotkeys_bg = theme.widget_bg_alt
theme.hotkeys_modifiers_fg = theme.orange
theme.hotkeys_font = theme.font_text .. "Medium 11"
theme.hotkeys_description_font = theme.font_text .. "Medium 10"
theme.hotkeys_label_font = theme.font_text .. "SemiBold 12"
theme.hotkeys_group_margin = dpi(20)

-- LAYOUT BOX
theme.layouts_icons_color = theme.fg_normal
theme.layout_fairh = themes_path .. "images/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "images/layouts/fairvw.png"
theme.layout_floating = themes_path .. "images/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "images/layouts/magnifierw.png"
theme.layout_max = themes_path .. "images/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "images/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "images/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "images/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "images/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "images/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "images/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "images/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "images/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "images/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "images/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "images/layouts/cornersew.png"
for _, layout_name in ipairs({
	"layout_fairh",
	"layout_fairv",
	"layout_floating",
	"layout_magnifier",
	"layout_max",
	"layout_fullscreen",
	"layout_tilebottom",
	"layout_tileleft",
	"layout_tile",
	"layout_tiletop",
	"layout_spiral",
	"layout_dwindle",
	"layout_cornernw",
	"layout_cornerne",
	"layout_cornersw",
	"layout_cornerse",
}) do
	theme[layout_name] = Gears.color.recolor_image(theme[layout_name], theme.layouts_icons_color)
end

Beautiful.init(theme)
