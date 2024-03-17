local dpi = Beautiful.xresources.apply_dpi

local function template(opts)
  local arc_bar = Wibox.widget({
    widget = Wibox.widget.progressbar,
    min_value = 0,
    max_value = 100,
    value = 0,
    forced_height = dpi(5),
    color = opts.color,
    shape = Helpers.shape.rrect(Beautiful.small_radius),
    bar_shape = Helpers.shape.rrect(Beautiful.small_radius),
    background_color = Helpers.color.lightness(
      Beautiful.color_method,
      Beautiful.color_method_factor,
      Beautiful.widget_bg_alt
    ),
  })

  if opts.update_fn then
    opts.update_fn(arc_bar)
  end

  return Wibox.widget({
    layout = Wibox.layout.fixed.horizontal,
    spacing = dpi(10),
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
    {
      layout = Wibox.container.place,
      arc_bar,
    },
  })
end

return template
