local modules = require(... .. ".modules")

return Wibox.widget({
  widget = Wibox.container.background,
  -- bg = Beautiful.neutral[850],
  -- shape = Helpers.shape.rrect(Beautiful.radius),
  -- border_width = Beautiful.widget_border.width,
  -- border_color = Beautiful.widget_border.color,
  {
    widget = Wibox.container.margin,
    -- margins = Beautiful.widget_padding.inner,
    {
      layout = Wibox.layout.flex.horizontal,
      spacing = Beautiful.widget_spacing,
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_spacing,
        modules.mute_state,
        modules.wifi_state,
      },
      {
        layout = Wibox.layout.flex.vertical,
        spacing = Beautiful.widget_spacing,
        {
          layout = Wibox.layout.flex.horizontal,
          spacing = Beautiful.widget_spacing,
          modules.test_2,
          modules.test_3,
        },
        modules.test,
      },
    },
  },
})
