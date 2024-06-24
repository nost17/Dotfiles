local clock = Wibox.widget({
   widget = Wibox.container.margin,
   top = Beautiful.widget_spacing * 0.5,
   bottom = Beautiful.widget_spacing * 0.5,
   {
      layout = Wibox.layout.align.horizontal,
      {
         widget = Wibox.widget.textclock,
         format = "%H:%M:%S",
         refresh = 1,
         font = Beautiful.font_name .. "Regular 30",
         halign = "left",
      },
      nil,
      {
         widget = Wibox.container.background,
         fg = Beautiful.fg_normal .. "CC",
         {
            widget = Wibox.widget.textclock,
            format = "%A,\n%B %d, %Y",
            font = Beautiful.font_name .. "Regular 10",
            halign = "left",
         },
      },
   },
})

return clock
