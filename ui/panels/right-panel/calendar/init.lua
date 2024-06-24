local dpi = Beautiful.xresources.apply_dpi
local calendar = require(... .. ".modules")

return Wibox.widget({
   layout = Wibox.layout.fixed.vertical,
   spacing = Beautiful.widget_padding.inner,
   {
      widget = Wibox.container.background,
      bg = Beautiful.neutral[850],
      border_color = Beautiful.widget_border.color,
      border_width = Beautiful.widget_border.width,
      shape = Helpers.shape.rrect(Beautiful.radius),
      {
         widget = Wibox.container.margin,
         -- bottom = Beautiful.widget_padding.inner,
         left = Beautiful.widget_padding.inner,
         right = Beautiful.widget_padding.inner,
         calendar.clock,
      },
   },
   calendar.calendar,
})
