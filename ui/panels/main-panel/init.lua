local dpi = Beautiful.xresources.apply_dpi
local module = require(... .. ".module")
User._priv.bar_size = dpi(36)
User._priv.bar_padding = dpi(4)

return function(s)
  s.mypromptbox = Awful.widget.prompt() -- Create a promptbox.

  -- Create the wibox
  s.mywibox = Awful.wibar({
    position = "top",
    screen = s,
    height = User._priv.bar_size,
    widget = {
      layout = Wibox.layout.align.horizontal,
      expand = "none",
      -- Left widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        module.quicksettings,
        {
          widget = Wibox.container.margin,
          top = User._priv.bar_padding,
          bottom = User._priv.bar_padding,
          {
            layout = Wibox.layout.fixed.horizontal,
            spacing = Beautiful.widget_spacing,
            module.launcher(),
            s.mypromptbox,
            module.tasklist(s),
          },
        },
      },
      -- Middle widgets.
      {
        widget = Wibox.container.margin,
        top = User._priv.bar_padding,
        bottom = User._priv.bar_padding,
        {
          widget = Wibox.container.background,
          shape = Helpers.shape.rrect(Beautiful.radius),
          border_width = Beautiful.widget_border.width,
          border_color = Beautiful.widget_border.color,
          module.taglist(s),
        },
      },
      -- Right widgets.
      {
        layout = Wibox.layout.fixed.horizontal,
        spacing = Beautiful.widget_spacing,
        {
          widget = Wibox.container.margin,
          margins = Beautiful.widget_padding.inner,
          Wibox.widget.systray(),
        },
        {
          widget = Wibox.container.margin,
          top = User._priv.bar_padding,
          bottom = User._priv.bar_padding,
          module.calendar,
        },
        {
          widget = Wibox.container.place,
          valign = "center",
        },
        {
          widget = Wibox.container.margin,
          margins = Beautiful.widget_padding.inner,
          module.layoutbox(s),
        },
      },
    },
  })
end
