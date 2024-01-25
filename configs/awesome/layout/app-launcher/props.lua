local dpi = Beautiful.xresources.apply_dpi
return {
  favorites = { "kitty", "firefox" },
  skip_empty_icons = false,
  shape = Helpers.shape.rrect(Beautiful.small_radius),
  placement = function(c)
    Helpers.placement(c, "top_left", nil, Beautiful.useless_gap * 2)
  end,
  border_color = Helpers.color.ldColor(
    Beautiful.color_method,
    Beautiful.color_method_factor / 2,
    Beautiful.widget_bg
  ),
  border_width = 0,
  background = Beautiful.widget_bg,
  icon_size = 48,
  apps_spacing = dpi(6),
  default_app_icon_name = "default-application",
  app_show_icon = true,
  app_name_halign = "left",
  apps_per_row = 6,
  apps_per_column = 1,
  apps_margin = 0,
  -- app_height = Dpi(24),
  app_icon_width = dpi(32),
  app_icon_height = dpi(32),
  app_width = dpi(260),
  app_shape = Helpers.shape.rrect(Beautiful.small_radius),
  app_content_padding = {
    left = dpi(6),
    right = dpi(6),
    bottom = dpi(4),
    top = dpi(4),
  },
  app_normal_color = Beautiful.widget_bg_color,
  app_normal_hover_color = Beautiful.widget_bg_alt,
  app_selected_color = Beautiful.widget_bg_alt,
  app_selected_hover_color = Helpers.color.ldColor(
    Beautiful.color_method,
    Beautiful.color_method_factor,
    Beautiful.widget_bg_alt
  ),
  app_name_selected_color = Beautiful.accent_color,
  app_name_normal_color = Beautiful.foreground .. "6F",
  app_name_font = Beautiful.font_text .. "Regular 12",
  prompt_image_bg_ratio = 3,
  prompt_image_bg_height = dpi(130),
  prompt_image_bg_shape = Helpers.shape.rrect(Beautiful.small_radius),
  prompt_height = dpi(40),
  prompt_margins = {
    right = dpi(70),
    left = dpi(70),
  },
  prompt_paddings = {
    left = dpi(12),
    right = dpi(10),
  },
  prompt_text = "",
  prompt_icon = "󰍉", -- 󰍉
  prompt_shape = Helpers.shape.rrect(Beautiful.small_radius),
  prompt_icon_font = Beautiful.font_icon .. "8",
  prompt_font = Beautiful.font_text .. "Regular 13",
  prompt_color = Beautiful.widget_bg,
  prompt_text_color = Beautiful.foreground .. "bb",
  prompt_icon_color = Beautiful.accent_color .. "DF",
  prompt_cursor_color = Beautiful.foreground .. "bb",
  grid_margins = dpi(15),
  grid_spacing = dpi(6),
}
