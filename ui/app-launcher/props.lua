local dpi = Beautiful.xresources.apply_dpi
-- local color_lib = Helpers.color
-- local hover_color = Beautiful.primary[500]
-- local hover_color = color_lib.lightness(
--   color_lib.isDark(Beautiful.accent_color) and "lighten" or "darken",
--   Beautiful.color_method_factor,
--   Beautiful.accent_color
-- )
return {
  save_history = false,
  terminal = "wezterm",
  reset_on_hide = true,
  favorites = { "wezterm", "firefox", "thunar" },
  skip_empty_icons = false,
  shrink_height = true,
  shape = Helpers.shape.rrect(Beautiful.widget_radius.outer),
  -- shape = function(cr, width, height)
  --   local arrow_size = Beautiful.widget_padding.outer * 1.5
  --   local pos = (arrow_size * 2) + User._priv.bar_size
  --   return Helpers.shape.infobubble(cr, width, height, Beautiful.radius, arrow_size, pos)
  -- end,
  placement = function(c)
    Helpers.placement(c, "top_left", nil, Beautiful.useless_gap * 2)
  end,
  border_color = Beautiful.widget_border.color,
  -- border_color = color_lib.lightness(Beautiful.color_method, Beautiful.color_method_factor / 2, Beautiful.widget_bg),
  border_width = Beautiful.widget_border.width,
  background = Beautiful.widget_color[1],
  icon_size = 48,
  apps_spacing = Beautiful.widget_spacing,
  default_app_icon_name = "default-application",
  app_show_icon = true,
  app_name_halign = "left",
  apps_per_row = 8,
  apps_per_column = 1,
  apps_margin = 0,
  -- app_height = Dpi(24),
  app_icon_width = dpi(28),
  app_icon_height = dpi(28),
  app_width = dpi(260),
  app_height = dpi(38),
  app_border_width = Beautiful.widget_border.width,
  app_normal_border_color = Beautiful.widget_color[1],
  app_normal_hover_border_color = Beautiful.widget_border.color,
  app_selected_hover_border_color = Beautiful.primary[700],
  app_selected_border_color = Beautiful.widget_border.color,
  app_shape = Helpers.shape.rrect(Beautiful.radius),
  app_content_spacing = dpi(8),
  app_content_padding = dpi(6),
  app_normal_color = Beautiful.widget_color[1],
  app_normal_hover_color = Beautiful.widget_color[2],
  app_selected_color = Beautiful.neutral[800],
  app_selected_hover_color = Beautiful.primary[800],
  app_name_selected_color = Beautiful.neutral[100],
  app_name_normal_color = Beautiful.neutral[100] .. "8F",
  app_name_font = Beautiful.font_med_s,
  prompt_image_bg_ratio = 3,
  prompt_image_bg_height = dpi(130),
  prompt_image_bg_shape = Helpers.shape.rrect(Beautiful.radius),
  prompt_height = dpi(40),
  prompt_margins = 0,
  prompt_paddings = {
    left = dpi(11),
    right = dpi(10),
  },
  prompt_text = "",
  prompt_icon = "󰕰", -- 󰍉
  prompt_shape = Helpers.shape.rrect(Beautiful.radius),
  prompt_icon_font = "Material Design Icons Desktop 8",
  prompt_font = Beautiful.font_med_s,
  prompt_color = Beautiful.widget_color[2],
  prompt_text_color = Beautiful.fg_normal .. "EE",
  prompt_icon_color = Beautiful.primary[500] .. "DF",
  prompt_cursor_color = Beautiful.neutral[100],
  prompt_separator_size = dpi(0),
  prompt_separator_color = Beautiful.primary[500],
  prompt_border_width = Beautiful.widget_border.width,
  prompt_border_color = Beautiful.widget_border.color,
  grid_margins = Beautiful.widget_padding.outer,
  grid_spacing = Beautiful.widget_spacing,
}
