local dpi = Beautiful.xresources.apply_dpi
local module = require(... .. ".module")

return function(s)
  s.mypromptbox = Awful.widget.prompt() -- Create a promptbox.

  -- Create the wibox
  s.mywibox = Awful.wibar({
    position = "top",
    screen = s,
    height = dpi(30),
    widget = {
      layout = Wibox.layout.align.horizontal,
      -- Left widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        -- module.launcher(),
        {
          widget = Wibox.container.margin,
          top = Beautiful.widget_spacing / 2,
          bottom = Beautiful.widget_spacing / 2,
          module.taglist(s),
        },
        s.mypromptbox,
        module.tasklist(s),
      },
      -- Middle widgets.
      nil,
      -- Right widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        Wibox.widget.systray(),
        Wibox.widget.textclock(), -- Create a textclock widget.
        -- module.layoutbox(s),
      },
    },
  })
end
