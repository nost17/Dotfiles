local clock = Wibox.widget({
  widget = Wibox.container.margin,
  -- left = 10,
  -- right = 10,
  {
    layout = Wibox.layout.fixed.vertical,
    {
      widget = Wibox.widget.textclock,
      format = "%H:%M:%S",
      refresh = 1,
      font = Beautiful.font_text .. "Regular 30",
      halign = "left",
    },
    {
      widget = Wibox.container.background,
      fg = Beautiful.fg_normal .. "CC",
      {
        widget = Wibox.widget.textclock,
        format = "%A, %B %d, %Y",
        font = Beautiful.font_text .. "Regular 10",
        halign = "left",
      },
    },
  },
})

return clock
