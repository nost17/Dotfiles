local dpi = Beautiful.xresources.apply_dpi
local monitor_size = dpi(60)

local function template(opts)
  local arc_bar = Wibox.widget({
    widget = Wibox.container.arcchart,
    value = 30,
    min_value = 0,
    max_value = 100,
    bg = Helpers.color.lightness(Beautiful.color_method, Beautiful.color_method_factor, Beautiful.widget_bg_alt),
    thickness = dpi(4),
    -- start_angle = math.pi * 1.5,
    rounded_edge = false,
    colors = {
      opts.color,
    },
    {
      layout = Wibox.container.place,
      {
        markup = Helpers.text.colorize_text(opts.icon, Beautiful.fg_normal .. "DD"),
        font = Beautiful.font_icon .. "14",
        halign = "center",
        valign = "center",
        widget = Wibox.widget.textbox,
      },
    },
  })

  if opts.update_fn then
    opts.update_fn(arc_bar)
  end

  return Wibox.widget({
    widget = Wibox.container.background,
    bg = Beautiful.widget_bg_alt,
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    {
      widget = Wibox.container.margin,
      margins = dpi(6),
      {
        layout = Wibox.container.place,
        forced_width = monitor_size,
        forced_height = monitor_size,
        arc_bar,
      },
    },
  })
end

return template
